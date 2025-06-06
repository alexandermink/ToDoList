//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Александр Минк on 01.12.2024.
//

import CoreData

// MARK: - CoreDataManagerInput
protocol CoreDataManagerInput {
    func createNewTask(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchTask(by id: Int64, completion: @escaping (Result<TaskModel, Error>) -> Void)
    func fetchAllTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func saveAllTasks(_ tasks: [TaskModel], completion: @escaping (Result<Void, Error>) -> Void)
    func searchTasks(with searchText: String, completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func toggleTaskCompletion(by id: Int64, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(by id: Int64, completion: @escaping (Result<Void, Error>) -> Void)
}

final class CoreDataManager {
    
    // MARK: - Locals
    
    private enum Locals {
        static let newTaskTitle = "Введите название"
        static let newTaskDescription = "Введите описание"
    }
    
    // MARK: - Properties
    
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    internal var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Фоновый контекст (инициализируется один раз и переиспользуется)
    internal let backgroundContext: NSManagedObjectContext
    
    // MARK: - Init
    
    // Продакшн‑инициализатор (sqlite‑файл)
    private init() {
        // 1) Создаём контейнер
        persistentContainer = NSPersistentContainer(name: "CoreData")
        // 2) Загружаем сторы
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        // 3) Основной контекст (viewContext) автоматически мерджит изменения из фонового
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        // 4) Инициализируем фоновый контекст один раз
        let bgContext = persistentContainer.newBackgroundContext()
        // Пусть viewContext тоже переносит изменения из bgContext
        bgContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext = bgContext
    }
    
    // Тестовый инициализатор (in‑memory)
    internal init(inMemoryContainerName name: String) {
        persistentContainer = NSPersistentContainer(name: name)
        
        // 1) Конфигурируем in‑memory store
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        // 2) Загружаем сторы
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in‑memory store: \(error)")
            }
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        let bgContext = persistentContainer.newBackgroundContext()
        bgContext.automaticallyMergesChangesFromParent = true
        backgroundContext = bgContext
    }
    
    // MARK: - Private Methods
    
    // Сохраняет контекст, если есть изменения
    private func saveContext(context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    // Возвращает следующий доступный ID: находим максимальный в текущем backgroundContext, +1, либо 0 если пусто
    private func getNextID(in context: NSManagedObjectContext) -> Int64 {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            if let last = try context.fetch(fetchRequest).first {
                return last.id + 1
            } else {
                return 0
            }
        } catch {
            print("Failed to fetch max id: \(error)")
            return 0
        }
    }
}

// MARK: - CoreDataManagerInput
extension CoreDataManager: CoreDataManagerInput {
    
    // MARK: - Create New Task
    func createNewTask(completion: @escaping (Result<Void, Error>) -> Void) {
        
        let context = backgroundContext
        
        context.perform {
            let nextID: Int64 = self.getNextID(in: context)
            
            let entity = TaskEntity(context: context)
            entity.id = nextID
            entity.title = Locals.newTaskTitle
            entity.desc = Locals.newTaskDescription
            entity.isCompleted = false
            // Неявно createdAt = Date() проставится через awakeFromInsert()
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                context.rollback()
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Save All Tasks (Insert or Update)
    func saveAllTasks(_ tasks: [TaskModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let context = backgroundContext
        
        context.perform {
            for task in tasks {
                let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
                fetchRequest.fetchLimit = 1
                
                do {
                    if let existing = try context.fetch(fetchRequest).first {
                        // Обновляем существующую сущность
                        existing.update(from: task)
                    } else {
                        // Вставляем новую сущность
                        let newEntity = TaskEntity(context: context)
                        newEntity.update(from: task)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
            }
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                context.rollback()
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Fetch One Task by ID
    func fetchTask(by id: Int64, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        let context = backgroundContext
        
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let entity = try context.fetch(fetchRequest).first {
                    let model = TaskModel(entity: entity)
                    DispatchQueue.main.async {
                        completion(.success(model))
                    }
                } else {
                    let error = NSError(domain: "TaskNotFound",
                                        code: 404,
                                        userInfo: [NSLocalizedDescriptionKey: "Task not found"])
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Fetch All Tasks
    func fetchAllTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        let context = backgroundContext
        
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            
            let sortByDate = NSSortDescriptor(key: "createdAt", ascending: true)
            fetchRequest.sortDescriptors = [sortByDate]
            
            do {
                let entities = try context.fetch(fetchRequest)
                let models = entities.map { TaskModel(entity: $0) }
                DispatchQueue.main.async {
                    completion(.success(models))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Search Tasks by Title Substring
    func searchTasks(with searchText: String, completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        let context = backgroundContext
        
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
            do {
                let results = try context.fetch(fetchRequest)
                let models = results.map { TaskModel(entity: $0) }
                DispatchQueue.main.async {
                    completion(.success(models))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Toggle Task Completion
    func toggleTaskCompletion(by id: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = backgroundContext
        
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let entity = try context.fetch(fetchRequest).first {
                    entity.isCompleted.toggle()
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    let error = NSError(domain: "TaskNotFound",
                                        code: 404,
                                        userInfo: [NSLocalizedDescriptionKey: "Task with id:\(id) not found."])
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } catch {
                context.rollback()
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Delete Task by ID
    func deleteTask(by id: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = backgroundContext
        
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let entityToDelete = try context.fetch(fetchRequest).first {
                    context.delete(entityToDelete)
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    let error = NSError(domain: "TaskNotFound",
                                        code: 404,
                                        userInfo: [NSLocalizedDescriptionKey: "Task not found"])
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } catch {
                context.rollback()
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

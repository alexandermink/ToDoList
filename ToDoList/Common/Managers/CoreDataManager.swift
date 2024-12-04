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
    func saveAllTasks(_ task: [TaskModel], completion: @escaping (Result<Void, Error>) -> Void)
    func searchTasks(with searchText: String, completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func toggleTaskCompletion(by id: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(by id: Int, completion: @escaping (Result<Void, Error>) -> Void)
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
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    
    // MARK: - Init
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "CoreData")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    
    // MARK: - Private methods
    
    private func saveContext(context: NSManagedObjectContext) {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func getNextID(completion: @escaping (Int64) -> Void) {
        
        let context = backgroundContext
        context.performAndWait {
            
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            fetchRequest.fetchLimit = 1
            
            do {
                if let task = try context.fetch(fetchRequest).first {
                    completion(task.id + 1)
                } else {
                    completion(0)
                }
            } catch {
                completion(0)
                print("Failed to fetch max id: \(error)")
            }
        }
    }
    
}


// MARK: - CoreDataManagerInput
extension CoreDataManager: CoreDataManagerInput {
    
    // MARK: - Create Task
    func createNewTask(completion: @escaping (Result<Void, Error>) -> Void) {
        
        let context = backgroundContext
        context.perform {
            
            let entity = TaskEntity(context: context)
            
            // Получаем следующий ID асинхронно
            self.getNextID { id in
                entity.id = id
                entity.title = Locals.newTaskTitle
                entity.desc = Locals.newTaskDescription
                entity.isCompleted = false
                entity.createdAt = Date()
                
                // Сохраняем контекст после обновления данных
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
    }

    
    
    // MARK: - Save Tasks
    func saveAllTasks(_ tasks: [TaskModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let context = backgroundContext
        context.perform {
            
            for task in tasks {
                
                let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
                fetchRequest.fetchLimit = 1
                
                do {
                    if let existingEntity = try context.fetch(fetchRequest).first {
                        // Обновляем существующую запись
                        existingEntity.update(from: task)
                    } else {
                        // Создаем новую запись
                        let newEntity = TaskEntity(context: context)
                        newEntity.update(from: task)
                    }
                } catch {
                    // Ошибка во время поиска
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

    
    // MARK: - Fetch Task by ID
    func fetchTask(by id: Int64, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        
        let context = backgroundContext
        context.perform {
            
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let result = try context.fetch(fetchRequest).first {
                    let task = TaskModel(entity: result)
                    
                    // Переключаемся на главный поток для передачи данных
                    DispatchQueue.main.async {
                        completion(.success(task))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(
                            .failure(
                                NSError(
                                    domain: "TaskNotFound",
                                    code: 404,
                                    userInfo: [NSLocalizedDescriptionKey: "Task not found"]
                                )
                            )
                        )
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
            do {
                let results = try context.fetch(fetchRequest)
                let tasks = results.map { TaskModel(entity: $0) }
                
                // Переключаемся на главный поток для передачи данных
                // Как вариант еще можно использовать context.performAndWait()
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    // MARK: -  Search Tasks
    func searchTasks(with searchText: String, completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        
        let context = backgroundContext
        context.perform {
            
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
            do {
                let results = try context.fetch(fetchRequest)
                let tasks = results.map { TaskModel(entity: $0) }
                
                // Передача результата на главный поток
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                // Передача ошибки на главный поток
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    
    // MARK: - Toggle Task Completion
    func toggleTaskCompletion(by id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = backgroundContext
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let task = try context.fetch(fetchRequest).first {
                    // Переключаем состояние выполнения задачи
                    task.isCompleted.toggle()
                    
                    // Сохраняем изменения в контексте
                    try context.save()
                    
                    // Уведомляем об успешной операции на главном потоке
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    // Если задача не найдена, возвращаем ошибку
                    DispatchQueue.main.async {
                        completion(
                            .failure(
                                NSError(
                                    domain: "TaskNotFound",
                                    code: 404,
                                    userInfo: [NSLocalizedDescriptionKey: "Task with id:\(id) not found."]
                                )
                            )
                        )
                    }
                }
            } catch {
                // Обрабатываем ошибки
                context.rollback()
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    
    // MARK: - Delete Task
    func deleteTask(by id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let context = backgroundContext
        context.perform {
            
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if let taskToDelete = results.first {
                    context.delete(taskToDelete)
                    
                    // Сохраняем изменения в фоне
                    try context.save()
                    
                    // Передаем успешный результат на главный поток
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    // Задача не найдена
                    DispatchQueue.main.async {
                        completion(
                            .failure(
                                NSError(
                                    domain: "TaskNotFound",
                                    code: 404,
                                    userInfo: [NSLocalizedDescriptionKey: "Task not found"]
                                )
                            )
                        )
                    }
                }
            } catch {
                // В случае ошибки откатываем изменения и передаем ошибку на главный поток
                context.rollback()
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

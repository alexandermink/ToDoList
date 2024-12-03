//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Александр Минк on 01.12.2024.
//

import CoreData

protocol CoreDataManagerInput {
    var context: NSManagedObjectContext { get }
    func createNewTask()
    func saveTasks(tasks: [TaskModel])
    func fetchTasks() -> [TaskModel]
    func fetchTask(by id: Int) -> TaskModel?
    func delete(task: TaskModel)
    func searchTasks(with searchText: String) -> [TaskModel]?
    func toggleTaskCompletion(by id: Int)
}

class CoreDataManager {
    
    // MARK: - Locals
    
    private enum Locals {
        static let title = "Название задачи"
        static let description = "Описание задачи"
    }
    
    
    // MARK: - Properties
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    
    // MARK: - Init
    
    private init() {}
    
    
    // MARK: - Private methods
    
    private func saveContext() {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func getNextID() -> Int64 {
        let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            if let task = try context.fetch(fetchRequest).first {
                return task.id + 1
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
    
    var context: NSManagedObjectContext {
        get {
            persistentContainer.viewContext
        }
    }
    
    func createNewTask() {
        let taskEntity = TaskModel(context: context)
        taskEntity.id = getNextID()
        taskEntity.title = Locals.title
        taskEntity.desc = Locals.description
        taskEntity.createdAt = Date()
        taskEntity.isCompleted = false
        
        saveContext()
    }
    
    func saveTasks(tasks: [TaskModel]) {
        tasks.forEach { task in
            
            let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
            
            if task.id != -1 {
                fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            }

            if (try? context.fetch(fetchRequest))?.isEmpty == true {
                let taskEntity = TaskModel(context: context)
                taskEntity.id = task.id == -1 ? getNextID() : task.id
                taskEntity.title = task.title
                taskEntity.desc = task.desc
                taskEntity.createdAt = task.createdAt == nil ? Date() : task.createdAt
                taskEntity.isCompleted = task.isCompleted
            }
        }
        saveContext()
    }
    
    func toggleTaskCompletion(by id: Int) {
        
        let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let task = try context.fetch(fetchRequest).first {
                task.isCompleted.toggle()
                try context.save()
            }
        } catch {
            print("Ошибка обновления задачи: \(error)")
        }
    }
    
    func fetchTasks() -> [TaskModel] {
        let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func fetchTask(by id: Int) -> TaskModel? {
        let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            return nil
        }
    }
    
    func searchTasks(with searchText: String) -> [TaskModel]? {
        let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
            return nil
        }
    }

    
    func delete(task: TaskModel) {
        context.delete(task)
        saveContext()
    }
    
}

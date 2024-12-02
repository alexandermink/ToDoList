//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Александр Минк on 01.12.2024.
//

import CoreData

protocol CoreDataManagerInput {
    var context: NSManagedObjectContext { get }
    func saveTasks(tasks: [TaskModel])
    func fetchTasks() -> [TaskModel]
}

class CoreDataManager {
    
    // MARK: - Properties
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
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
    
}


// MARK: - CoreDataManagerInput
extension CoreDataManager: CoreDataManagerInput {
    
    var context: NSManagedObjectContext {
        get {
            persistentContainer.viewContext
        }
    }
    
    func saveTasks(tasks: [TaskModel]) {
        let context = self.context
        tasks.forEach { task in
            if !context.insertedObjects.contains(task) {
                context.insert(task)
            }
        }
        saveContext()
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
    
}

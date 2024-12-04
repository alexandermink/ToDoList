//
//  CoreDataManagerTests.swift
//  ToDoListTests
//
//  Created by Александр Минк on 04.12.2024.
//

import XCTest
import CoreData
@testable import ToDoList

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var persistentContainer: NSPersistentContainer!
    var viewContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        // Создание контейнера в памяти для тестирования
        persistentContainer = NSPersistentContainer(name: "CoreData")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        coreDataManager = CoreDataManager.shared // или инициализировать через зависимости
        viewContext = persistentContainer.viewContext
    }
    
    override func tearDownWithError() throws {
        coreDataManager = nil
        persistentContainer = nil
        viewContext = nil
    }
    
    
    // MARK: - Test: Search Tasks
    
    func testSearchTasks() throws {
        let expectation = self.expectation(description: "Task should be found by search text")
        
        coreDataManager.createNewTask { result in
            switch result {
            case .success():
                self.coreDataManager.searchTasks(with: "Введите") { result in
                    switch result {
                    case .success(let tasks):
                        XCTAssertGreaterThan(tasks.count, 0, "Should find at least one task")
                        expectation.fulfill()
                    case .failure(let error):
                        XCTFail("Failed to search tasks: \(error)")
                    }
                }
            case .failure(let error):
                XCTFail("Failed to create task: \(error)")
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

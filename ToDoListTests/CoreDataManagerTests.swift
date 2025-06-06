//
//  CoreDataManagerTests.swift
//  ToDoListTests
//
//  Created by Александр Минк on 04.12.2024.
//

import XCTest
import CoreData
@testable import ToDoList

final class CoreDataManagerTests: XCTestCase {
    var manager: CoreDataManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        manager = CoreDataManager(inMemoryContainerName: "CoreData")
    }
    
    override func tearDownWithError() throws {
        manager = nil
        try super.tearDownWithError()
    }
    
    func testCreateNewTask_insertsTaskWithDefaultValues() {
        let expect = expectation(description: "createNewTask completion")
        
        manager.createNewTask { result in
            switch result {
            case .success:
                let context = self.manager.viewContext
                let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                
                do {
                    let all = try context.fetch(fetchRequest)
                    XCTAssertEqual(all.count, 1)
                    guard let entity = all.first else {
                        XCTFail("No TaskEntity found")
                        return
                    }
                    XCTAssertEqual(entity.title, "Введите название")
                    XCTAssertEqual(entity.desc, "Введите описание")
                    XCTAssertFalse(entity.isCompleted)
                    XCTAssertNotNil(entity.createdAt)
                    XCTAssertGreaterThanOrEqual(entity.id, 0)
                } catch {
                    XCTFail("Fetch failed: \(error)")
                }
            case .failure(let error):
                XCTFail("createNewTask failed: \(error)")
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchAllAndFetchByID() {
        let exp1 = expectation(description: "first create")
        let exp2 = expectation(description: "second create")
        
        manager.createNewTask { _ in exp1.fulfill() }
        manager.createNewTask { _ in exp2.fulfill() }
        
        wait(for: [exp1, exp2], timeout: 1.0)
        
        let fetchAllExp = expectation(description: "fetchAllTasks")
        let fetchByIDExp = expectation(description: "fetchByID")
        
        manager.fetchAllTasks { result in
            switch result {
            case .success(let models):
                XCTAssertEqual(models.count, 2, "Should be 2 tasks")
                
                let ids = Set(models.map { $0.id })
                XCTAssertEqual(ids.count, 2, "IDs must be unique")
                
                if let firstID = models.first?.id {
                    self.manager.fetchTask(by: firstID) { resultByID in
                        switch resultByID {
                        case .success(let model):
                            XCTAssertEqual(model.id, firstID)
                            XCTAssertEqual(model.title, "Введите название")
                            XCTAssertEqual(model.desc, "Введите описание")
                            XCTAssertFalse(model.isCompleted)
                            XCTAssertNotNil(model.createdAt)
                        case .failure(let error):
                            XCTFail("fetchTask(by:) failed: \(error)")
                        }
                        fetchByIDExp.fulfill()
                    }
                } else {
                    XCTFail("No ID found after fetchAllTasks")
                    fetchByIDExp.fulfill()
                }
                
            case .failure(let error):
                XCTFail("fetchAllTasks failed: \(error)")
                fetchByIDExp.fulfill()
            }
            fetchAllExp.fulfill()
        }
        
        wait(for: [fetchAllExp, fetchByIDExp], timeout: 1.0)
    }

    
    func testSaveAllTasks_insertsAndUpdatesCorrectly() {
        let now = Date()
        let model1 = TaskModel(id: 10, title: "A", desc: "Desc A", createdAt: now, isCompleted: false)
        let model2 = TaskModel(id: 20, title: "B", desc: "Desc B", createdAt: now, isCompleted: true)
        
        let saveExp1 = expectation(description: "first saveAllTasks")
        manager.saveAllTasks([model1, model2]) { result in
            switch result {
            case .success:
                let ctx = self.manager.viewContext
                let fetch: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                do {
                    let entities = try ctx.fetch(fetch)
                    XCTAssertEqual(entities.count, 2)
                    let ids = Set(entities.map { $0.id })
                    XCTAssertTrue(ids.contains(10))
                    XCTAssertTrue(ids.contains(20))
                } catch {
                    XCTFail("Fetch after insert failed: \(error)")
                }
            case .failure(let error):
                XCTFail("saveAllTasks (insert) failed: \(error)")
            }
            saveExp1.fulfill()
        }
        wait(for: [saveExp1], timeout: 1.0)
        
        let modified = TaskModel(id: 10, title: "A-modified", desc: "Desc-modified", createdAt: now, isCompleted: true)
        let saveExp2 = expectation(description: "second saveAllTasks (update)")
        manager.saveAllTasks([modified]) { result in
            switch result {
            case .success:
                let ctx = self.manager.viewContext
                let fetchReq: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
                fetchReq.predicate = NSPredicate(format: "id == %d", 10)
                do {
                    let found = try ctx.fetch(fetchReq)
                    XCTAssertEqual(found.count, 1)
                    let entity = found.first!
                    XCTAssertEqual(entity.title, "A-modified")
                    XCTAssertEqual(entity.desc, "Desc-modified")
                    XCTAssertTrue(entity.isCompleted)
                } catch {
                    XCTFail("Fetch after update failed: \(error)")
                }
            case .failure(let error):
                XCTFail("saveAllTasks (update) failed: \(error)")
            }
            saveExp2.fulfill()
        }
        wait(for: [saveExp2], timeout: 1.0)
    }
    
    func testSearchTasks_filtersBySubstring() {
        let now = Date()
        let t1 = TaskModel(id: 1, title: "Купить молоко", desc: nil, createdAt: now, isCompleted: false)
        let t2 = TaskModel(id: 2, title: "Починить машину", desc: nil, createdAt: now, isCompleted: false)
        let t3 = TaskModel(id: 3, title: "Купить хлеб", desc: nil, createdAt: now, isCompleted: false)
        
        let saveExp = expectation(description: "save for search")
        manager.saveAllTasks([t1, t2, t3]) { _ in saveExp.fulfill() }
        wait(for: [saveExp], timeout: 1.0)
        
        let searchExp = expectation(description: "searchTasks")
        manager.searchTasks(with: "Купить") { result in
            switch result {
            case .success(let found):
                XCTAssertEqual(found.count, 2)
                let titles = Set(found.map { $0.title })
                XCTAssertTrue(titles.contains("Купить молоко"))
                XCTAssertTrue(titles.contains("Купить хлеб"))
            case .failure(let error):
                XCTFail("searchTasks failed: \(error)")
            }
            searchExp.fulfill()
        }
        wait(for: [searchExp], timeout: 1.0)
    }
    
    func testToggleTaskCompletion_togglesBoolean() {
        let now = Date()
        let t = TaskModel(id: 5, title: "ToggleMe", desc: nil, createdAt: now, isCompleted: false)
        
        let saveExp = expectation(description: "save for toggle")
        manager.saveAllTasks([t]) { _ in saveExp.fulfill() }
        wait(for: [saveExp], timeout: 1.0)
        
        let ctx = manager.viewContext
        var fetched: TaskEntity!
        do {
            let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            req.predicate = NSPredicate(format: "id == %d", 5)
            let arr = try ctx.fetch(req)
            XCTAssertEqual(arr.count, 1)
            fetched = arr.first!
            XCTAssertFalse(fetched.isCompleted)
        } catch {
            XCTFail("Fetch before toggle failed: \(error)")
        }
        
        let toggleExp1 = expectation(description: "toggle once")
        manager.toggleTaskCompletion(by: 5) { result in
            switch result {
            case .success:
                do {
                    let arr = try ctx.fetch(TaskEntity.fetchRequest()) as! [TaskEntity]
                    let after = arr.first { $0.id == 5 }
                    XCTAssertNotNil(after)
                    XCTAssertTrue(after!.isCompleted)
                } catch {
                    XCTFail("Fetch after first toggle failed: \(error)")
                }
            case .failure(let error):
                XCTFail("toggleTaskCompletion (1) failed: \(error)")
            }
            toggleExp1.fulfill()
        }
        wait(for: [toggleExp1], timeout: 1.0)
        
        let toggleExp2 = expectation(description: "toggle twice")
        manager.toggleTaskCompletion(by: 5) { result in
            switch result {
            case .success:
                do {
                    let arr = try ctx.fetch(TaskEntity.fetchRequest()) as! [TaskEntity]
                    let after = arr.first { $0.id == 5 }
                    XCTAssertNotNil(after)
                    XCTAssertFalse(after!.isCompleted)
                } catch {
                    XCTFail("Fetch after second toggle failed: \(error)")
                }
            case .failure(let error):
                XCTFail("toggleTaskCompletion (2) failed: \(error)")
            }
            toggleExp2.fulfill()
        }
        wait(for: [toggleExp2], timeout: 1.0)
    }
    
    func testDeleteTask_removesEntityOrReturnsError() {
        let now = Date()
        let t = TaskModel(id: 99, title: "ToDelete", desc: nil, createdAt: now, isCompleted: false)
        
        let saveExp = expectation(description: "save for delete")
        manager.saveAllTasks([t]) { _ in saveExp.fulfill() }
        wait(for: [saveExp], timeout: 1.0)
        
        let ctx = manager.viewContext
        do {
            let allBefore = try ctx.fetch(TaskEntity.fetchRequest()) as! [TaskEntity]
            XCTAssertTrue(allBefore.contains(where: { $0.id == 99 }))
        } catch {
            XCTFail("Fetch before delete failed: \(error)")
        }
        
        let deleteExp1 = expectation(description: "delete existing")
        manager.deleteTask(by: 99) { result in
            switch result {
            case .success:
                do {
                    let allAfter = try ctx.fetch(TaskEntity.fetchRequest()) as! [TaskEntity]
                    XCTAssertFalse(allAfter.contains(where: { $0.id == 99 }))
                } catch {
                    XCTFail("Fetch after delete failed: \(error)")
                }
            case .failure(let error):
                XCTFail("deleteTask failed when deleting existing: \(error)")
            }
            deleteExp1.fulfill()
        }
        wait(for: [deleteExp1], timeout: 1.0)
        
        let deleteExp2 = expectation(description: "delete non‑existing")
        manager.deleteTask(by: 99) { result in
            switch result {
            case .success:
                XCTFail("deleteTask should've failed for non‑existing entity")
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, "TaskNotFound")
                XCTAssertEqual(error.code, 404)
            default:
                XCTFail("Unexpected result when deleting non‑existing")
            }
            deleteExp2.fulfill()
        }
        wait(for: [deleteExp2], timeout: 1.0)
    }
}

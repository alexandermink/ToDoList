//
//  ToDoListNetworkServiceTests.swift
//  ToDoListTests
//
//  Created by Александр Минк on 06.06.2025.
//

import XCTest
import Alamofire
@testable import ToDoList

// Мок‑версия AlamofireServiceInput
final class MockAlamofireService: AlamofireServiceInput {
    // Результат, который вернём из request(_:method:parameters:headers:completion:)
    var resultToReturn: Result<ToDoListModel, Error>?
    
    // Флаг, что метод request(...) был вызван
    private(set) var requestCalled = false
    
    // Сохраним последний endpoint, чтобы проверить, что ToDoListNetworkService вызывается с правильным "/todos"
    private(set) var lastEndpoint: String?

    func request<T>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String : Any]?,
        headers: HTTPHeaders?,
        completion: @escaping (Result<T, Error>) -> Void
    ) where T : Codable {
        
        requestCalled = true
        lastEndpoint = endpoint
        
        // Ожидаем, что T == ToDoListModel (иначе приведём к ошибке)
        guard let result = resultToReturn else {
            // Если результат не задан, возвращаем пустую модель
            let empty = ToDoListModel(todos: [])
            if let casted = empty as? T {
                completion(.success(casted))
            } else {
                let err = NSError(
                    domain: "MockAlamofireService",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "No result configured"]
                )
                completion(.failure(err))
            }
            return
        }
        
        switch result {
        case .success(let model):
            // Пытаемся привести model к T
            if let casted = model as? T {
                completion(.success(casted))
            } else {
                let err = NSError(
                    domain: "MockAlamofireService",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Type mismatch in mock"]
                )
                completion(.failure(err))
            }
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

final class ToDoListNetworkServiceTests: XCTestCase {
    
    var mockAlamofire: MockAlamofireService!
    var networkService: ToDoListNetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAlamofire = MockAlamofireService()
        networkService = ToDoListNetworkService(alamofireService: mockAlamofire)
    }
    
    override func tearDownWithError() throws {
        mockAlamofire = nil
        networkService = nil
        try super.tearDownWithError()
    }
    
    // Тестируем успешное получение данных с API
   func testFetchTasks_success() {
        // Готовим несколько ToDoTask и оборачиваем в ToDoListModel
        let expectedTodos = [
            ToDoTask(id: 1, todo: "First Task",  completed: false, userId: 10),
            ToDoTask(id: 2, todo: "Second Task", completed: true,  userId: 10),
            ToDoTask(id: 3, todo: "Third Task",  completed: false, userId: 11)
        ]
        let fakeModel = ToDoListModel(todos: expectedTodos)
        
        // Задаем resultToReturn, чтобы mock вернул именно этот ToDoListModel
        mockAlamofire.resultToReturn = .success(fakeModel)
        
        let expect = expectation(description: "fetchTasks completion")
        
        networkService.fetchTasks { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(model, fakeModel, "Сервис должен вернуть точь-в-точь тот же ToDoListModel")
                XCTAssertEqual(model.todos.count, expectedTodos.count)
                XCTAssertEqual(model.todos[0].todo, "First Task")
                XCTAssertEqual(model.todos[1].completed, true)
                XCTAssertEqual(model.todos[2].userId, 11)
                
            case .failure(let error):
                XCTFail("Ожидали успех, но получили ошибку: \(error)")
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
        // Дополнительно проверяем, что mock‑сервис действительно был вызван
        XCTAssertTrue(mockAlamofire.requestCalled, "Метод AlamofireService.request(...) должен был быть вызван")
    }
    
    // Тестируем ситуацию, когда API возвращает ошибку
    func testFetchTasks_failure() {
        // 1) Готовим искусственную ошибку
        enum TestError: Error, Equatable {
            case networkFailed
        }
        mockAlamofire.resultToReturn = .failure(TestError.networkFailed)
        
        // 2) Ожидание
        let expect = expectation(description: "fetchTasks failure completion")
        
        // 3) Вызываем fetchTasks и проверяем, что completion приходит с ошибкой
        networkService.fetchTasks { result in
            switch result {
            case .success(let model):
                XCTFail("Ожидали ошибку, но получили модель: \(model)")
            case .failure(let error):
                // Убедимся, что это именно TestError.networkFailed
                XCTAssertTrue(error is TestError, "Ожидали TestError.networkFailed, но получили \(error)")
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
        XCTAssertTrue(mockAlamofire.requestCalled, "MockAlamofireService.request должен быть вызван при ошибке")
    }
    
    // Опциональный тест: проверяем, что ToDoListNetworkService вызвал endpoint "/todos"
    func testRequestEndpoint_isCorrect() {
        let expect = expectation(description: "fetchTasks endpoint check")
        mockAlamofire.resultToReturn = .success(ToDoListModel(todos: []))
        
        networkService.fetchTasks { _ in
            // Проверяем, что метод request получил endpoint "/todos"
            XCTAssertEqual(self.mockAlamofire.lastEndpoint, "/todos",
                           "ToDoListNetworkService должен запрашивать endpoint '/todos'")
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
}

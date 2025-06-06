//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import Foundation

protocol ToDoListInteractorInput {
    func createNewTask(completion: @escaping (Result<Void, Error>) -> Void)
    func firstFetchTasks(completion: @escaping (ToDoListModel) -> Void)
    func fetchTask(by id: Int, completion: @escaping (Result<TaskModel, Error>) -> Void)
    func fetchTasks(completion: @escaping ([TaskModel]) -> Void)
    func saveTasks(tasks: [TaskModel])
    func searchTasks(with searchText: String, completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func toggleTaskCompletion(by id: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(by id: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ToDoListInteractor {
    
    // MARK: - Properties
    
    weak var presenter: ToDoListInteractorOutput?
    
    private let networkService: ToDoListNetworkServiceInput
    private let coreDataManager: CoreDataManagerInput
    
    
    // MARK: - Init
    
    init(networkService: ToDoListNetworkServiceInput,
         coreDataManager: CoreDataManagerInput) {
        
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
    
}


// MARK: - ToDoListInteractorInput
extension ToDoListInteractor: ToDoListInteractorInput {
    
    func createNewTask(completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataManager.createNewTask(completion: completion)
    }
    
    func firstFetchTasks(completion: @escaping (ToDoListModel) -> Void) {
        
        networkService.fetchTasks { response in
            
            switch response {
            case .success(let data):
                completion(data)
            case .failure(let error):
                self.presenter?.showAlert(error: error)
            }
        }
    }
    
    func fetchTask(by id: Int, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        
        coreDataManager.fetchTask(by: Int64(id)) { result in
            
            switch result {
            case .success(let task):
                completion(.success(task))
            case .failure(let error):
                self.presenter?.showAlert(error: error)
            }
        }
    }
    
    func fetchTasks(completion: @escaping ([TaskModel]) -> Void) {
        
        coreDataManager.fetchAllTasks { result in
            
            switch result {
            case .success(let tasks):
                completion(tasks)
            case .failure(let error):
                self.presenter?.showAlert(error: error)
            }
        }
    }
    
    func saveTasks(tasks: [TaskModel]) {
        
        coreDataManager.saveAllTasks(tasks) { result in
            
            switch result {
            case .success(_):
                self.presenter?.reloadData()
            case .failure(let error):
                self.presenter?.showAlert(error: error)
            }
        }
    }
    
    func searchTasks(with searchText: String, completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        coreDataManager.searchTasks(with: searchText, completion: completion)
    }
    
    func toggleTaskCompletion(by id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataManager.toggleTaskCompletion(by: Int64(id), completion: completion)
    }
    
    func deleteTask(by id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataManager.deleteTask(by: Int64(id), completion: completion)
    }
    
}

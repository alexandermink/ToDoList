//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import Foundation

protocol ToDoListInteractorInput {
    func fetchTask(by id: Int, completion: @escaping (TaskModel) -> Void)
    func createNewTask()
    func fetchTasks()
    func toggleTaskCompletion(by id: Int)
    func saveTasks(tasks: [TaskModel])
    func searchTasks(with searchText: String) -> [TaskModel]?
    func deleteTask(task: TaskModel)
}

final class ToDoListInteractor {
    
    // MARK: - Properties
    
    weak var presenter: ToDoListInteractorOutput?
    
    private let networkService: ToDoListNetworkServiceInput
    private let coreDataManager: CoreDataManagerInput
    private let userDefaults: UserDefaults
    
    
    // MARK: - Init
    
    init(networkService: ToDoListNetworkServiceInput,
         coreDataManager: CoreDataManagerInput,
         userDefaults: UserDefaults) {
        
        self.networkService = networkService
        self.coreDataManager = coreDataManager
        self.userDefaults = userDefaults
    }
    
}


// MARK: - ToDoListInteractorInput
extension ToDoListInteractor: ToDoListInteractorInput { 
    
    func fetchTask(by id: Int, completion: @escaping (TaskModel) -> Void) {
        guard let task = coreDataManager.fetchTask(by: id) else {
            return
        }
        completion(task)
    }
    
    func createNewTask() {
        coreDataManager.createNewTask()
    }
    
    func toggleTaskCompletion(by id: Int) {
        coreDataManager.toggleTaskCompletion(by: id)
    }
    
    func fetchTasks() {
        
        if userDefaults.isAppRunBefore {
            presenter?.updateViewWithTasks(tasks: coreDataManager.fetchTasks())
        } else {
            
            networkService.fetchTasks { response in
                
                switch response {
                case .success(let data):
                    self.userDefaults.isAppRunBefore = true
                    self.presenter?.updateViewWithTasks(tasks: data)
                case .failure(let error):
                    self.presenter?.showAlert(error: error)
                }
            }
        }
        
    }
    
    func saveTasks(tasks: [TaskModel]) {
        coreDataManager.saveTasks(tasks: tasks)
    }
    
    func searchTasks(with searchText: String) -> [TaskModel]? {
        coreDataManager.searchTasks(with: searchText)
    }
    
    func deleteTask(task: TaskModel) {
        coreDataManager.delete(task: task)
    }
    
}

//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import Foundation

protocol ToDoListInteractorInput { 
    func fetchTasks()
    func saveTasks(tasks: [TaskModel])
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
    
}

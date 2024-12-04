//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import Foundation

protocol ToDoListViewOutput: ViewOutput { 
    func createTask()
    func toggleTaskCompletion(by id: Int)
    func searchTasks(with searchText: String)
}

protocol ToDoListInteractorOutput: AnyObject { 
    func reloadData()
    func updateViewWithTasks(tasks: ToDoListModel)
    func updateViewWithTasks(tasks: [TaskModel])
    func showAlert(error: Error)
    func didToggleTaskCompletion(by id: Int)
}

final class ToDoListPresenter {
    
    // MARK: - Properties
    
    weak var view: ToDoListViewInput?
    
    var interactor: ToDoListInteractorInput?
    var router: ToDoListRouterInput?

    private let dataConverter: ToDoListDataConverterInput
    private let userDefaults: UserDefaults
    
    
    // MARK: - Init
    
    init(dataConverter: ToDoListDataConverterInput, userDefaults: UserDefaults) {
        self.dataConverter = dataConverter
        self.userDefaults = userDefaults
    }
    
}


// MARK: - ToDoListViewOutput
extension ToDoListPresenter: ToDoListViewOutput {
    
    func viewIsReady() { 
        
        if !userDefaults.isAppRunBefore {
            userDefaults.isAppRunBefore = true
            interactor?.firstFetchTasks { model in
                self.interactor?.saveTasks(tasks: self.dataConverter.convert(model))
                self.view?.update(with: self.dataConverter.convert(model))
            }
        }
        
    }
    
    func viewWillAppear() {
        reloadData()
    }
    
    func loadViewIfNeeded() {
        reloadData()
    }
    
    func createTask() {
        
        interactor?.createNewTask { result in
            
            switch result {
            case .success(_):
                self.reloadData()
            case .failure(let error):
                self.showAlert(error: error)
            }
        }
    }
    
    func toggleTaskCompletion(by id: Int) {
        interactor?.toggleTaskCompletion(by: id) { result in
            
            switch result {
            case .success(_):
                self.reloadData()
            case .failure(let error):
                self.showAlert(error: error)
            }
        }
    }
    
    func searchTasks(with searchText: String) {
        
        if searchText.isEmpty {
            reloadData()
        } else {
            interactor?.searchTasks(with: searchText) { result in
                
                switch result {
                case .success(let filteredTasks):
                    self.view?.update(with: self.dataConverter.convert(filteredTasks))
                case .failure(let error):
                    self.showAlert(error: error)
                }
            }
        }
        
    }
    
}


// MARK: - ToDoListInteractorOutput
extension ToDoListPresenter: ToDoListInteractorOutput {
    
    func reloadData() {
        interactor?.fetchTasks { tasks in
            self.view?.update(with: self.dataConverter.convert(tasks))
        }
    }
    
    func updateViewWithTasks(tasks: ToDoListModel) {
        interactor?.saveTasks(tasks: dataConverter.convert(tasks))
        view?.update(with: dataConverter.convert(tasks))
    }
    
    func updateViewWithTasks(tasks: [TaskModel]) {
        view?.update(with: dataConverter.convert(tasks))
    }
    
    func showAlert(error: Error) {
        view?.showAlert(title: error.localizedDescription, style: .alert)
    }
    
    func didToggleTaskCompletion(by id: Int) {
        reloadData()
    }
    
}


// MARK: - ToDoListTableViewManagerDelegate
extension ToDoListPresenter: ToDoListTableViewManagerDelegate { 
    
    func openTask(by id: Int) {
        
        interactor?.fetchTask(by: id) { result in
            
            switch result {
            case .success(let task):
                self.router?.openTaskDetail(task: task, moduleOutput: self)
            case .failure(let error):
                self.showAlert(error: error)
            }
        }
    }
    
    func deleteTask(by id: Int) {
        
        interactor?.deleteTask(by: id) { result in
            
            switch result {
            case .success(_):
                self.reloadData()
            case .failure(let error):
                self.showAlert(error: error)
            }
        }
    }
    
    func didTapStatusButton(forTaskWithID id: Int) {
        
        interactor?.toggleTaskCompletion(by: id) { result in
            
            switch result {
            case .success(_):
                self.reloadData()
            case .failure(let error):
                self.showAlert(error: error)
            }
        }
    }
    
}


// MARK: - TaskDetailModuleOutput
extension ToDoListPresenter: TaskDetailModuleOutput {  }

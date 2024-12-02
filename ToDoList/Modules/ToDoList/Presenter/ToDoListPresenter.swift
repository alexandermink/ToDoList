//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol ToDoListViewOutput: ViewOutput { 
    func fetchTasks()
}

protocol ToDoListInteractorOutput: AnyObject { 
    func updateViewWithTasks(tasks: ToDoListModel)
    func updateViewWithTasks(tasks: [TaskModel])
    func showAlert(error: Error)
}

final class ToDoListPresenter {
    
    // MARK: - Properties
    
    weak var view: ToDoListViewInput?
    
    var interactor: ToDoListInteractorInput?
    var router: ToDoListRouterInput?

    private let dataConverter: ToDoListDataConverterInput
    
    
    // MARK: - Init
    
    init(dataConverter: ToDoListDataConverterInput) {
        self.dataConverter = dataConverter
    }
    
}


// MARK: - ToDoListViewOutput
extension ToDoListPresenter: ToDoListViewOutput {
    
    func viewIsReady() {
        fetchTasks()
    }
    
    func fetchTasks() {
        interactor?.fetchTasks()
    }
    
}


// MARK: - ToDoListInteractorOutput
extension ToDoListPresenter: ToDoListInteractorOutput {
    
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
    
}


// MARK: - ToDoListTableViewManagerDelegate
extension ToDoListPresenter: ToDoListTableViewManagerDelegate {  }

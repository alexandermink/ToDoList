//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol ToDoListViewOutput: ViewOutput { 
    func fetchTasks()
    func createTask()
    func toggleTaskCompletion(by id: Int)
    func searchTasks(with searchText: String)
}

protocol ToDoListInteractorOutput: AnyObject { 
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
    
    
    // MARK: - Init
    
    init(dataConverter: ToDoListDataConverterInput) {
        self.dataConverter = dataConverter
    }
    
}


// MARK: - ToDoListViewOutput
extension ToDoListPresenter: ToDoListViewOutput {
    
    func viewIsReady() {  }
    
    func loadViewIfNeeded() {
        interactor?.fetchTasks()
    }
    
    func fetchTasks() {
        interactor?.fetchTasks()
    }
    
    func createTask() {
        interactor?.createNewTask()
        fetchTasks()
    }
    
    func toggleTaskCompletion(by id: Int) {
        interactor?.toggleTaskCompletion(by: id)
    }
    
    func searchTasks(with searchText: String) {
        
        if searchText.isEmpty {
            fetchTasks()
        } else {
            guard let filteredTasks = interactor?.searchTasks(with: searchText) else {
                return
            }
            view?.update(with: dataConverter.convert(filteredTasks))
        }
        
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
    
    func didToggleTaskCompletion(by id: Int) {
        fetchTasks()
    }
    
}


// MARK: - ToDoListTableViewManagerDelegate
extension ToDoListPresenter: ToDoListTableViewManagerDelegate { 
    
    func openTask(by id: Int) {
        
        interactor?.fetchTask(by: id) { task in
            self.router?.openTaskDetail(task: task)
        }
    }
    
    func deleteTask(by id: Int) {
        
        interactor?.fetchTask(by: id) { task in
            self.interactor?.deleteTask(task: task)
        }
        interactor?.fetchTasks()
    }
    
    func didTapStatusButton(forTaskWithID id: Int) {
        interactor?.toggleTaskCompletion(by: id)
        fetchTasks()
    }
    
}

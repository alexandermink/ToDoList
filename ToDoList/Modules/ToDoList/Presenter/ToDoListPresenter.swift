//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol ToDoListViewOutput: ViewOutput { 
    func fetchTasks()
}

protocol ToDoListInteractorOutput: AnyObject {  }

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
        interactor?.fetchTasks { tasksModel in
            self.view?.update(with: self.dataConverter.convert(tasksModel))
        }
    }
    
}


// MARK: - ToDoListInteractorOutput
extension ToDoListPresenter: ToDoListInteractorOutput {  }


// MARK: - ToDoListTableViewManagerDelegate
extension ToDoListPresenter: ToDoListTableViewManagerDelegate {  }

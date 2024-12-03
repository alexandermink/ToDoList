//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol TaskDetailViewOutput: ViewOutput { 
    func saveTask(task: TaskModel)
}

protocol TaskDetailInteractorOutput: AnyObject {  }

final class TaskDetailPresenter {
    
    // MARK: - Properties
    
    weak var view: TaskDetailViewInput?
    
    var interactor: TaskDetailInteractorInput?
    var router: TaskDetailRouterInput?
        
    private var task: TaskModel
    
    init(taskModel: TaskModel) {
        self.task = taskModel
    }
    
}


// MARK: - TaskDetailViewOutput
extension TaskDetailPresenter: TaskDetailViewOutput {
    
    func viewIsReady() { 
        view?.setTask(task: task)
    }
    
    func saveTask(task: TaskModel) {
        interactor?.saveTask(task: task)
    }
    
}


// MARK: - TaskDetailInteractorOutput
extension TaskDetailPresenter: TaskDetailInteractorOutput {  }

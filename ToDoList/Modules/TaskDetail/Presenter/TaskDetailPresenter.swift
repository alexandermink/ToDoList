//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol TaskDetailViewOutput: ViewOutput {  }

final class TaskDetailPresenter {
    
    // MARK: - Properties
    
    weak var view: TaskDetailViewInput?
    
    var router: TaskDetailRouterInput?
    
}


// MARK: - TaskDetailViewOutput
extension TaskDetailPresenter: TaskDetailViewOutput {
    
    func viewIsReady() {  }
    
}

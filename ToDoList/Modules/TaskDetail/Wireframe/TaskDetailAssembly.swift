//
//  TaskDetailAssembly.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

final class TaskDetailAssembly: Assembly {
    
    static func assembleModule() -> Module {
        
        let view = TaskDetailViewController()
        let router = TaskDetailRouter(transition: view)
        let presenter = TaskDetailPresenter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        
        return view
    }

}


// MARK: - Model
extension TaskDetailAssembly {
    
    struct Model: TransitionModel {  }
    
}

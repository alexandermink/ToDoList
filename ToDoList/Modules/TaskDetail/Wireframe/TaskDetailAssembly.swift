//
//  TaskDetailAssembly.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

final class TaskDetailAssembly: Assembly {
    
    static func assembleModule(with model: TransitionModel) -> Module {
        
        guard let model = model as? Model else {
            fatalError("Некорректная модель в модуле TaskDetailAssembly")
        }
        
        let managers = ManagerFactory.shared
        
        let coreDataManager = managers.coreDataManager
                
        let view = TaskDetailViewController()
        let router = TaskDetailRouter(transition: view)
        let presenter = TaskDetailPresenter(taskModel: model.task)
        let interactor = TaskDetailInteractor(coreDataManager: coreDataManager)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        return view
    }
    
}


// MARK: - Model
extension TaskDetailAssembly {
    
    struct Model: TransitionModel { 
        let task: TaskModel
    }
    
}

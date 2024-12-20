//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol TaskDetailRouterInput { 
    func closeModule()
}

final class TaskDetailRouter {
    
    // MARK: - Properties
    
    private unowned let transition: ModuleTransitionHandler
    
    
    // MARK: - Init
    
    init(transition: ModuleTransitionHandler) {
        self.transition = transition
    }
    
}


// MARK: - TaskDetailRouterInput
extension TaskDetailRouter: TaskDetailRouterInput { 
    
    func closeModule() {
        transition.closeCurrentModule()
    }
    
}

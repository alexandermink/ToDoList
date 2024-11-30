//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol ToDoListRouterInput { 
    func openTaskDetail(task: ToDoTask)
}

final class ToDoListRouter {
    
    // MARK: - Properties
    
    private unowned let transition: ModuleTransitionHandler
    
    
    // MARK: - Init
    
    init(transition: ModuleTransitionHandler) {
        self.transition = transition
    }
    
}


// MARK: - ToDoListRouterInput
extension ToDoListRouter: ToDoListRouterInput { 
    
    func openTaskDetail(task: ToDoTask) {
        print("Open TaskDetail Module")
//        transition.push(with: TaskDetailAssembly.Model(task: task), openModuleType: TaskDetailAssembly.self)
    }
    
}

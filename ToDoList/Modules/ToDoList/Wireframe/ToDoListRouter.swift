//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol ToDoListRouterInput { 
    func openTaskDetail(task: TaskModel, moduleOutput: TaskDetailModuleOutput?)
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
    
    func openTaskDetail(task: TaskModel, moduleOutput: TaskDetailModuleOutput?) {
        let model = TaskDetailAssembly.Model(moduleOutput: moduleOutput, task: task)
        transition.push(with: model,
                        openModuleType: TaskDetailAssembly.self,
                        animated: false)
    }
    
}

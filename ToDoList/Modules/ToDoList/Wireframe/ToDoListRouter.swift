//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol ToDoListRouterInput {  }

final class ToDoListRouter {
    
    // MARK: - Properties
    
    private unowned let transition: ModuleTransitionHandler
    
    
    // MARK: - Init
    
    init(transition: ModuleTransitionHandler) {
        self.transition = transition
    }
    
}


// MARK: - ToDoListRouterInput
extension ToDoListRouter: ToDoListRouterInput {  }

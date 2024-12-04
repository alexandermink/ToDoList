//
//  AppCoordinator.swift
//  ToDoList
//
//  Created by Александр Минк on 29.11.2024.
//

import UIKit

protocol AppCoordinatorInput {
    func startFlow(onWindow window: UIWindow)
    func showNeededFlow()
}

final class AppCoordinator {
    
    // MARK: - Properties
    
    private lazy var rootNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = false
        return navigationController
    }()
}


// MARK: - AppCoordinatorInput
extension AppCoordinator: AppCoordinatorInput {
    
    func startFlow(onWindow window: UIWindow) {
        window.rootViewController = rootNavigationController
        showNeededFlow()
    }
    
    func showNeededFlow() {
        rootNavigationController.viewControllers.append(ToDoListAssembly.assembleModule())
    }
}

//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Александр Минк on 29.11.2024.
//

import UIKit

@main
final class AppDelegate: UIResponder {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    private lazy var coordinator: AppCoordinatorInput = {
        ManagerFactory.shared.appCoordinator
    }()
    
    
    // MARK: - Private methods
    
    private func startFlow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        coordinator.startFlow(onWindow: window)
        window.makeKeyAndVisible()
        self.window = window
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        startFlow()
        return true
    }
}

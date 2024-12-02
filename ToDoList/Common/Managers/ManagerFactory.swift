//
//  ManagerFactory.swift
//  ToDoList
//
//  Created by Александр Минк on 29.11.2024.
//

import Foundation

final class ManagerFactory {
    
    // MARK: - Properties
    
    static let shared = ManagerFactory()
    
    private(set) lazy var appCoordinator: AppCoordinatorInput = AppCoordinator()
    
    private let services = ServiceFactory.shared
    
    var coreDataManager: CoreDataManagerInput {
        CoreDataManager.shared
    }
    
    
    // MARK: - Init
    
    private init() {  }
    
}


// MARK: - NSCopying
extension ManagerFactory: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        self
    }
}

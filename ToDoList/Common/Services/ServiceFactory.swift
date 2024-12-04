//
//  ServiceFactory.swift
//  ToDoList
//
//  Created by Александр Минк on 29.11.2024.
//

import Foundation

final class ServiceFactory {
    
    // MARK: - Properties
    
    static let shared = ServiceFactory()
    
    
    // MARK: - NetworkServices
    
    var alamofireService: AlamofireServiceInput {
        AlamofireService.shared
    }
    
    
    // MARK: - Storages
    
    var standardUserDefaults: UserDefaults {
        .standard
    }
    
    
    // MARK: - Init
    
    private init() {  }
    
}


// MARK: - NSCopying
extension ServiceFactory: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        self
    }
}

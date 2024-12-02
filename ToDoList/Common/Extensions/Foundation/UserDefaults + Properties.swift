//
//  UserDefaults + Properties.swift
//  ToDoList
//
//  Created by Александр Минк on 01.12.2024.
//

import Foundation

extension UserDefaults {
    
    // MARK: - Types
    
    private enum Keys {
        static let isAppRunBefore = "isAppRunBefore"
    }
    
    
    // MARK: - Properties
    
    var isAppRunBefore: Bool {
        get {
            bool(forKey: Keys.isAppRunBefore)
        }
        set {
            set(newValue, forKey: Keys.isAppRunBefore)
        }
    }
}

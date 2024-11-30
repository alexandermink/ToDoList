//
//  VIPERModuleAssembly.swift
//  ToDoList
//
//  Created by Александр Минк on 29.11.2024.
//

import UIKit

typealias Module = UIViewController

protocol Assembly {
    static func assembleModule(with model: TransitionModel) -> Module
    static func assembleModule() -> Module
}

extension Assembly {
    
    static func assembleModule(with model: TransitionModel) -> Module {
        fatalError("Реализуй метод assembleModule(with model: TransitionModel)")
    }
    
    static func assembleModule() -> Module {
        fatalError("Реализуй метод assembleModule()")
    }
    
}

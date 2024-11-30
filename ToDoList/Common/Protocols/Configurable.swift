//
//  Configurable.swift
//  ToDoList
//
//  Created by Александр Минк on 30.11.2024.
//

protocol Configurable {
    
    associatedtype Model
    
    func configure(with model: Model)
}

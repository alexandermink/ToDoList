//
//  ToDoListModel.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

struct ToDoListModel: Codable, Equatable {
    let todos: [ToDoTask]
}

struct ToDoTask: Codable, Equatable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

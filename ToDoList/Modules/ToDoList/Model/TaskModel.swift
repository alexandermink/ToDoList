//
//  TaskModel.swift
//  ToDoList
//
//  Created by Александр Минк on 04.12.2024.
//

import Foundation

// MARK: - TaskModel
struct TaskModel: Identifiable {
    
    // MARK: - Properties
    
    let id: Int64
    let title: String
    let desc: String?
    let createdAt: Date
    let isCompleted: Bool
    
    // MARK: - Init

    init(id: Int64,
         title: String,
         desc: String?,
         createdAt: Date,
         isCompleted: Bool) {
        self.id = id
        self.title = title
        self.desc = desc
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
    
    // Инициализатор из TaskEntity
    init(entity: TaskEntity) {
        self.id = entity.id
        self.title = entity.title
        self.desc = entity.desc
        self.createdAt = entity.createdAt
        self.isCompleted = entity.isCompleted
    }
}

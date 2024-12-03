//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import Foundation

struct ToDoListViewModel {
    let rows: [Row]
}


// MARK: - ToDoListViewModel
extension ToDoListViewModel {
    
    struct Row {
        
        let reusableIdentifier: String
        let id: Int
        let title: String
        let description: String?
        let date: Date
        let isCompleted: Bool

        init(id: Int,
             title: String,
             description: String?,
             date: Date,
             isCompleted: Bool) {
            
            self.reusableIdentifier = String(describing: ToDoTableViewCell.self)
            self.id = id
            self.title = title
            self.description = description
            self.date = date
            self.isCompleted = isCompleted
        }
    }
    
}

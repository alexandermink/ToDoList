//
//  ToDoListDataConverter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import Foundation

protocol ToDoListDataConverterInput {
    func convert(_ model: ToDoListModel) -> ToDoListViewModel
    func convert(_ model: [TaskModel]) -> ToDoListViewModel
    func convert(_ model: ToDoListModel) -> [TaskModel]
}

final class ToDoListDataConverter { 
    
    // MARK: - Types
    
    typealias Row = ToDoListViewModel.Row
    
    
    // MARK: - Properties
    
    private let coreDataManager: CoreDataManagerInput
    
    
    // MARK: - Init
    
    init(coreDataManager: CoreDataManagerInput) {
        self.coreDataManager = coreDataManager
    }
    
    
    // MARK: - Private methods
    
    private func createRow(task: ToDoTask) -> Row {
        Row(id: task.id, title: task.todo, description: nil, date: Date(), isCompleted: task.completed)
    }
    
    private func createRow(task: TaskModel) -> Row {
        Row(id: Int(task.id),
            title: task.title,
            description: task.desc,
            date: task.createdAt ?? Date(),
            isCompleted: task.isCompleted)
    }
    
}


// MARK: - ToDoListDataConverterInput
extension ToDoListDataConverter: ToDoListDataConverterInput {
    
    func convert(_ model: ToDoListModel) -> ToDoListViewModel {
        ToDoListViewModel(rows: model.todos.map { createRow(task: $0) })
    }
    
    func convert(_ model: [TaskModel]) -> ToDoListViewModel {
        ToDoListViewModel(rows: model.sorted { $1.id < $0.id  }.map { createRow(task: $0) })
    }
    
    func convert(_ model: ToDoListModel) -> [TaskModel] {
        model.todos.map {
            TaskModel(id: Int64($0.id), title: $0.todo, desc: nil, createdAt: Date(), isCompleted: $0.completed)
        }
    }
    
}

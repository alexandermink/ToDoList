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
        
        let configurator: TableCellConfiguratorProtocol
        
        let date = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone.current

        let dateString = formatter.string(from: date)
        
        configurator = ToDoTableViewCellConfigurator(
            model: ToDoTableViewCell.Model(
                id: task.id,
                title: task.todo,
                description: nil,
                date: dateString,
                isCompleted: task.completed
            ),
            cellHeight: 90
        )
        
        return .base(configurator)
        
    }
    
    private func createRow(task: TaskModel) -> Row {
        
        let configurator: TableCellConfiguratorProtocol
        
        let date = task.createdAt

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone.current

        let dateString = formatter.string(from: date)
        
        configurator = ToDoTableViewCellConfigurator(
            model: ToDoTableViewCell.Model(
                id: Int(task.id),
                title: task.title,
                description: task.desc,
                date:  dateString,
                isCompleted: task.isCompleted
            ),
            cellHeight: 90
        )
        
        return .base(configurator)
        
    }
    
}


// MARK: - ToDoListDataConverterInput
extension ToDoListDataConverter: ToDoListDataConverterInput {
    
    func convert(_ model: ToDoListModel) -> ToDoListViewModel {
        ToDoListViewModel(rows: model.todos.map { createRow(task: $0) })
    }
    
    func convert(_ model: [TaskModel]) -> ToDoListViewModel {
        ToDoListViewModel(rows: model.sorted { $0.id < $1.id  }.map { createRow(task: $0) })
    }
    
    func convert(_ model: ToDoListModel) -> [TaskModel] {
        var tasks: [TaskModel] = []
        model.todos.forEach { task in
            let taskModel = TaskModel(context: coreDataManager.context)
            taskModel.id = Int64(task.id)
            taskModel.title = task.todo
            taskModel.desc = nil
            taskModel.createdAt = Date()
            taskModel.isCompleted = task.completed
            tasks.append(taskModel)
        }
        return tasks
    }
    
}

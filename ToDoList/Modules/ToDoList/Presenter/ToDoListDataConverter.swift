//
//  ToDoListDataConverter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import Foundation

protocol ToDoListDataConverterInput {
    func convert(_ model: ToDoListModel) -> ToDoListViewModel
}

final class ToDoListDataConverter { 
    
    // MARK: - Types
    
    typealias Row = ToDoListViewModel.Row
    
    
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
                title: task.todo,
                description: nil,
                date: dateString,
                isCompleted: task.completed
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
    
}

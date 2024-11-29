//
//  ToDoListDataConverter.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol ToDoListDataConverterInput {
    func convert(_ model: ToDoListModel) -> ToDoListViewModel?
}

final class ToDoListDataConverter {  }


// MARK: - ToDoListDataConverterInput
extension ToDoListDataConverter: ToDoListDataConverterInput {
    
    func convert(_ model: ToDoListModel) -> ToDoListViewModel? {
        return nil
    }
    
}

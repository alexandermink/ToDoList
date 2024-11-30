//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

struct ToDoListViewModel {
    let rows: [Row]
}


// MARK: - ToDoListViewModel
extension ToDoListViewModel {
    
    enum Row {
        
        case base(TableCellConfiguratorProtocol)
        
        
        // MARK: - Properties
        
        var configurator: TableCellConfiguratorProtocol {
            
            switch self {
            case .base(let configurator):
                return configurator
            }
        }
        
        var id: String {
            type(of: configurator).id
        }
        
    }
    
}

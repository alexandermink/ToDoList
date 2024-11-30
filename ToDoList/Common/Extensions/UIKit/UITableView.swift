//
//  UITableView.swift
//  ToDoList
//
//  Created by Александр Минк on 30.11.2024.
//

import UIKit

extension UITableView {
    
    // MARK: - Public methods
    
    func register(_ cellTypes: UITableViewCell.Type...) {
        
        cellTypes.forEach {
            register($0, forCellReuseIdentifier: String(describing: $0) )
        }
        
    }
}

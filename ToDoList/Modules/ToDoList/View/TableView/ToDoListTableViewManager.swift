//
//  ToDoListTableViewManager.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import UIKit

protocol ToDoListTableViewManagerDelegate: AnyObject {  }

protocol ToDoListTableViewManagerInput {
    func setup(tableView: UITableView)
    func update(with viewModel: ToDoListViewModel)
}

final class ToDoListTableViewManager: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: ToDoListTableViewManagerDelegate?
    
    private weak var tableView: UITableView?
    
    private var viewModel: ToDoListViewModel?
    
}


// MARK: - ToDoListTableViewManagerInput
extension ToDoListTableViewManager: ToDoListTableViewManagerInput {
    
    func setup(tableView: UITableView) {
        
        // Configure your table view here
        //
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoTableViewCell.self)
        
        //...
        
        self.tableView = tableView
    }
    
    func update(with viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        tableView?.reloadData()
    }
    
}


// MARK: - UITableViewDataSource
extension ToDoListTableViewManager: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = viewModel?.rows[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: row.id, for: indexPath)
        row.configurator.configure(cell)
        return cell
        
    }
    
}


// MARK: - UITableViewDelegate
extension ToDoListTableViewManager: UITableViewDelegate { 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel?.rows[indexPath.row].configurator.cellHeight ?? 0
    }
    
}

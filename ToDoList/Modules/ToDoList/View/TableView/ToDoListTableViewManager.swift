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
        //        tableView.delegate = self
        //        tableView.dataSource = self
        
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
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}


// MARK: - UITableViewDelegate
//extension ToDoListTableViewManager: UITableViewDelegate {  }

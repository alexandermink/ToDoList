//
//  ToDoListTableViewManager.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import UIKit

protocol ToDoListTableViewManagerDelegate: AnyObject {
    func openTask(by id: Int)
    func deleteTask(by id: Int)
    func didTapStatusButton(forTaskWithID id: Int)
}

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
        
        guard let task = viewModel?.rows[indexPath.row],
              let cell = tableView.dequeueReusableCell(
                withIdentifier: task.reusableIdentifier,
                for: indexPath
              ) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone.current

        let dateString = formatter.string(from: task.date)
        
        cell.configure(
            with: ToDoTableViewCell.Model(
                id: task.id,
                title: task.title,
                description: task.description,
                date: dateString,
                isCompleted: task.isCompleted
            )
        )
        cell.delegate = self
        
        return cell
        
    }
    
}


// MARK: - UITableViewDelegate
extension ToDoListTableViewManager: UITableViewDelegate { 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let task = viewModel?.rows[indexPath.row] else {
            return
        }
        
        delegate?.openTask(by: task.id)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            guard let task = viewModel?.rows[indexPath.row] else {
                return
            }
            
            delegate?.deleteTask(by: task.id)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

extension ToDoListTableViewManager: ToDoTableViewCellDelegate {
    
    func didTapStatusButton(forTaskWithID id: Int) {
        delegate?.didTapStatusButton(forTaskWithID: id)
    }
}

//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import UIKit

protocol ToDoListViewInput: AnyObject { 
    func update(with viewModel: ToDoListViewModel)
}

final class ToDoListViewController: UIViewController {
	
    // MARK: - Public properties
    
	var presenter: ToDoListViewOutput?
    var tableViewManager: ToDoListTableViewManagerInput?
    
    private let tableView = UITableView()
    
    
    // MARK: - Life cycle
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        drawSelf()
        presenter?.viewIsReady()
    }
    
    
    // MARK: - Private Methods
    
    private func drawSelf() {
        view.backgroundColor = .black
        
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.showsVerticalScrollIndicator = false
//        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableViewManager?.setup(tableView: tableView)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}


// MARK: - ToDoListViewInput
extension ToDoListViewController: ToDoListViewInput {
    
    func update(with viewModel: ToDoListViewModel) {
        tableViewManager?.update(with: viewModel)
    }
    
}

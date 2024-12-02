//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import UIKit

protocol ToDoListViewInput: Alertable { 
    func update(with viewModel: ToDoListViewModel)
}

final class ToDoListViewController: UIViewController {
    
    // MARK: - Locals
    
    private enum Locals {
        static let navigationTitle = "Задачи"
    }
	
    
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
        
        title = Locals.navigationTitle
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .black
        
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.showsVerticalScrollIndicator = false
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

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
        static let backButtonTitle = "Назад"
        static let taskCountPrefix = " Задач"
        static let textFieldPlaceholder = "Название задачи"
        static let descriptionViewText = "Описание задачи"
    }
	
    
    // MARK: - Public properties
    
	var presenter: ToDoListViewOutput?
    var tableViewManager: ToDoListTableViewManagerInput?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView = UITableView()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let taskCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 задач"
        label.font = .systemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.pencil")
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    
    // MARK: - Life cycle
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        drawSelf()
        presenter?.viewIsReady()
    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        presenter?.loadViewIfNeeded()
    }
    
    
    // MARK: - Private Methods
    
    private func drawSelf() {
        
        title = Locals.navigationTitle
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск задач"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let backButton = UIBarButtonItem()
        backButton.title = Locals.backButtonTitle
        backButton.tintColor = .systemYellow
        navigationItem.backBarButtonItem = backButton
        
        view.backgroundColor = .black
        
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.showsVerticalScrollIndicator = false
        tableViewManager?.setup(tableView: tableView)
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(bottomView.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(83)
        }
        
        bottomView.addSubview(taskCountLabel)
        
        taskCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        bottomView.addSubview(addTaskButton)
        
        addTaskButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(22)
        }
        
        addTaskButton.addTarget(self, action: #selector(didTapAddTaskButton), for: .touchUpInside)
    }
    
    
    // MARK: - Actions
    
    @objc private func didTapAddTaskButton() {
        presenter?.createTask()
    }
}


// MARK: - ToDoListViewInput
extension ToDoListViewController: ToDoListViewInput {
    
    func update(with viewModel: ToDoListViewModel) {
        taskCountLabel.text = "\(viewModel.rows.count)\(Locals.taskCountPrefix)"
        tableViewManager?.update(with: viewModel)
    }
    
}


// MARK: - UISearchResultsUpdating
extension ToDoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        presenter?.searchTasks(with: searchText)
    }
    
}

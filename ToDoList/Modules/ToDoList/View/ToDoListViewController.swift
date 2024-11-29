//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import UIKit

protocol ToDoListViewInput: AnyObject {  }

final class ToDoListViewController: UIViewController {
	
    // MARK: - Public properties
    
	var presenter: ToDoListViewOutput?
    var tableViewManager: ToDoListTableViewManagerInput?
    
    
    // MARK: - Life cycle
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        drawSelf()
        presenter?.viewIsReady()
    }
    
    
    // MARK: - Private Methods
    
    private func drawSelf() { 
        view.backgroundColor = .red
    }
}


// MARK: - ToDoListViewInput
extension ToDoListViewController: ToDoListViewInput {
    
}

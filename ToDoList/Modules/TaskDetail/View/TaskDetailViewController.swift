//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import UIKit

protocol TaskDetailViewInput: AnyObject {  }

final class TaskDetailViewController: UIViewController {
	
    // MARK: - Public properties
    
	var presenter: TaskDetailViewOutput?
    
    
    // MARK: - Life cycle
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        drawSelf()
        presenter?.viewIsReady()
    }
    
    
    // MARK: - Drawning
    
    private func drawSelf() {  }
    
}


// MARK: - TaskDetailViewInput
extension TaskDetailViewController: TaskDetailViewInput {
    
}

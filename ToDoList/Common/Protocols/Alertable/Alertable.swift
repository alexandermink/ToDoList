//
//  Alertable.swift
//  ToDoList
//
//  Created by Александр Минк on 01.12.2024.
//

import UIKit

protocol Alertable: AnyObject {
    
    func showAlert(title: String, style: UIAlertController.Style)
    func showAlert(title: String, style: UIAlertController.Style, actions: [AlertAction])
    func showAlert(title: String,
                   message: String?,
                   style: UIAlertController.Style,
                   actions: [AlertAction],
                   animated: Bool)
}


// MARK: - Default implementation
extension Alertable where Self: UIViewController {
    
    func showAlert(title: String, style: UIAlertController.Style) {
        showAlert(title: title, message: nil, style: style, actions: [.ok], animated: true)
    }
    
    func showAlert(title: String, style: UIAlertController.Style, actions: [AlertAction]) {
        showAlert(title: title, message: nil, style: style, actions: actions, animated: true)
    }
    
    func showAlert(title: String,
                   message: String? = nil,
                   style: UIAlertController.Style,
                   actions: [AlertAction],
                   animated: Bool = true) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { model in
            let action = UIAlertAction(title: model.title, style: model.style) { _ in
                model.action?()
            }
            
            action.setValue(model.titleColor, forKey: SystemKeys.titleTextColor)
            alert.addAction(action)
        }
        
        present(alert, animated: animated)
    }
    
}


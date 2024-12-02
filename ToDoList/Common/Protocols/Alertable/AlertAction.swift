//
//  AlertAction.swift
//  ToDoList
//
//  Created by Александр Минк on 01.12.2024.
//

import UIKit

struct AlertAction {
    
    // MARK: - Locals
    
    private enum Locals {
        static let ok = "OK"
        static let titleColor: UIColor = .black
    }
    
    
    // MARK: - Properties
    
    static let ok = AlertAction(title: Locals.ok)
    
    let title: String
    let titleColor: UIColor
    let style: UIAlertAction.Style
    let action: (() -> Void)?
    
    
    // MARK: - Init
    
    init(title: String,
         titleColor: UIColor = Locals.titleColor,
         style: UIAlertAction.Style = .default,
         action: (() -> Void)? = nil) {
        
        self.title = title
        self.titleColor = titleColor
        self.style = style
        self.action = action
    }
}


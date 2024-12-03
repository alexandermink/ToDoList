//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

import UIKit

protocol TaskDetailViewInput: AnyObject { 
    func setTask(task: TaskModel?)
}

final class TaskDetailViewController: NLViewController {
    
    // MARK: - Locals
    
    private enum Locals {
        static let textFieldPlaceholder = "Введите название задачи"
        static let descriptionViewText = "Введите описание задачи"
    }
    
	
    // MARK: - Public properties
    
	var presenter: TaskDetailViewOutput?
    
    var task: TaskModel?
    
    private let titleField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 34, weight: .bold)
        textField.placeholder = Locals.textFieldPlaceholder
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let descriptionView: UITextView = {
        let textView = UITextView()
        textView.text = Locals.descriptionViewText
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    
    // MARK: - Life cycle
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        drawSelf()
        presenter?.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveTask()
    }
    
    
    // MARK: - Drawning
    
    private func drawSelf() {
                
        [
            titleField, descriptionView, dateLabel
        ].forEach {
            view.addSubview($0)
        }
                
        titleField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    
    // MARK: - Private methods
    
    private func saveTask() {
        
        guard let task = self.task else {
            return
        }
        
        task.title = titleField.text ?? ""
        
        if descriptionView.text == Locals.descriptionViewText {
            task.desc = nil
        } else {
            task.desc = descriptionView.text
        }
        
        presenter?.saveTask(task: task)
    }
    
}


// MARK: - TaskDetailViewInput
extension TaskDetailViewController: TaskDetailViewInput {
    
    func setTask(task: TaskModel?) {
        
        self.task = task
        
        titleField.text = task?.title
        if task?.desc != nil && task?.desc != "" {
            descriptionView.text = task?.desc
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone.current

        let dateString = formatter.string(from: task?.createdAt ?? Date())
        
        dateLabel.text = dateString
    }
    
}

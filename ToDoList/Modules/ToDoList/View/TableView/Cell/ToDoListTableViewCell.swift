//
//  ToDoListTableViewCell.swift
//  ToDoList
//
//  Created by Александр Минк on 30.11.2024.
//

import UIKit
import SnapKit

typealias ToDoTableViewCellConfigurator = TableCellConfigurator<ToDoTableViewCell, ToDoTableViewCell.Model>

class ToDoTableViewCell: NLTableViewCell {
    
    // MARK: - Locals
    
    private enum Locals {
        static let statusIconSize: CGFloat = 20
    }
    
    
    // MARK: - Properties
    
    private var id: Int?
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusIcon = UIImageView()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        drawSelf()
    }
    
    
    // MARK: - Drawing
    
    private func drawSelf() {
        contentView.backgroundColor = .black
        selectionStyle = .none
        
        // Настройки titleLabel
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        
        // Настройки descriptionLabel
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        // Настройки dateLabel
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        dateLabel.textColor = .white
        contentView.addSubview(dateLabel)
        
        // Настройки statusIcon
        statusIcon.contentMode = .scaleAspectFit
        contentView.addSubview(statusIcon)
        
        statusIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(Locals.statusIconSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(statusIcon.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}



// MARK: - Configurable
extension ToDoTableViewCell: Configurable {
    
    func configure(with model: Model) {
        id = model.id
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        dateLabel.text = model.date
        
        let icon = model.isCompleted ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        statusIcon.image = icon
        statusIcon.tintColor = model.isCompleted ? .systemGreen : .systemGray
    }
    
}


// MARK: - Model
extension ToDoTableViewCell {
    
    struct Model {
        
        // MARK: - Properties
        
        let id: Int
        let title: String
        let description: String?
        let date: String
        let isCompleted: Bool
        
        
        // MARK: - Init
        
        init(id: Int, title: String, description: String?, date: String, isCompleted: Bool = false) {
            self.id = id
            self.title = title
            self.description = description
            self.date = date
            self.isCompleted = isCompleted
        }
    }
}

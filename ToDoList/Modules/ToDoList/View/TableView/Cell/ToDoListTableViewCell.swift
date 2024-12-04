//
//  ToDoListTableViewCell.swift
//  ToDoList
//
//  Created by Александр Минк on 30.11.2024.
//

import UIKit
import SnapKit

typealias ToDoTableViewCellConfigurator = TableCellConfigurator<ToDoTableViewCell, ToDoTableViewCell.Model>

protocol ToDoTableViewCellDelegate: AnyObject {
    func didTapStatusButton(forTaskWithID id: Int)
}

class ToDoTableViewCell: NLTableViewCell {
    
    // MARK: - Locals
    
    private enum Locals {
        static let statusIconSize: CGFloat = 24
    }
    
    
    // MARK: - Properties
    
    weak var delegate: ToDoTableViewCellDelegate?
    
    private var id: Int?
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusButton = UIButton()
    
    
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
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 3
        contentView.addSubview(descriptionLabel)
        
        // Настройки dateLabel
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        dateLabel.textColor = .white
        contentView.addSubview(dateLabel)
        
        // Настройки statusIcon
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .all
        configuration.imagePadding = 0
        configuration.contentInsets = .zero

        statusButton.configuration = configuration
        statusButton.configurationUpdateHandler = { button in
            button.imageView?.contentMode = .scaleAspectFill
        }
        contentView.addSubview(statusButton)
        
        statusButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(Locals.statusIconSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(statusButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        statusButton.addTarget(self, action: #selector(didTapStatusButton), for: .touchUpInside)

    }
    
    
    // MARK: - Private methods
    
    @objc private func didTapStatusButton() {
        guard let id = id else { return }
        delegate?.didTapStatusButton(forTaskWithID: id)
    }
    
}



// MARK: - Configurable
extension ToDoTableViewCell: Configurable {
    
    func configure(with model: Model) {
        
        id = model.id
        
        let attributedString: NSMutableAttributedString
        
        if model.isCompleted {
            attributedString = NSMutableAttributedString(string: model.title, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.gray
            ])
        } else {
            attributedString = NSMutableAttributedString(string: model.title, attributes: [
                .foregroundColor: UIColor.white
            ])
        }
        
        titleLabel.attributedText = attributedString
        
        descriptionLabel.text = model.description
        descriptionLabel.textColor = model.isCompleted ? .systemGray : .white
        dateLabel.text = model.date
        dateLabel.textColor = .systemGray
        
        let icon = model.isCompleted ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        statusButton.setImage(icon, for: .normal)
        statusButton.tintColor = model.isCompleted ? .systemYellow : .systemGray
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
        
        init(id: Int, title: String, description: String?, date: String, isCompleted: Bool) {
            self.id = id
            self.title = title
            self.description = description
            self.date = date
            self.isCompleted = isCompleted
        }
    }
}

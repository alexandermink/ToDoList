//
//  TableCellConfiguratorProtocol.swift
//  ToDoList
//
//  Created by Александр Минк on 30.11.2024.
//

import CoreGraphics

protocol TableCellConfiguratorProtocol: ViewConfiguratorProtocol {
    static var id: String { get }
    var cellHeight: CGFloat { get }
}

//
//  TaskEntity+CoreDataClass.swift
//  ToDoList
//
//  Created by Александр Минк on 01.12.2024.
//
//

import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        
        if createdAt == nil {
            createdAt = Date()
        }
    }
    
}

extension TaskEntity {

    // MARK: - Properties
    
    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var desc: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool
    
    
    // MARK: - Public methods
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }
    
    func update(from model: TaskModel) {
        self.id = model.id
        self.title = model.title
        self.desc = model.desc
        self.createdAt = model.createdAt
        self.isCompleted = model.isCompleted
    }

}

extension TaskEntity : Identifiable {  }

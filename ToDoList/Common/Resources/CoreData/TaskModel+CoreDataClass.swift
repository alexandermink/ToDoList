//
//  TaskModel+CoreDataClass.swift
//  ToDoList
//
//  Created by Александр Минк on 01.12.2024.
//
//

import Foundation
import CoreData

@objc(TaskModel)
public class TaskModel: NSManagedObject {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        
        if createdAt == nil {
            createdAt = Date()
        }
    }
    
}

extension TaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
        return NSFetchRequest<TaskModel>(entityName: "TaskModel")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var desc: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool

}

extension TaskModel : Identifiable {

}

//
//  ToDo+CoreDataProperties.swift
//  ToDoList
//
//  Created by Nirav Goswami on 2022-11-11.
//
//

import Foundation
import CoreData
import UIKit

extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var dueDate: Date?
    @NSManaged public var createdDate: Date?
    @NSManaged public var hasDueDate: Bool
    @NSManaged public var notes: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String?

}

extension ToDo : Identifiable {

}

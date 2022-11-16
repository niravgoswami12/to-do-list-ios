//
//  Todo.swift
//  ToDoList
//
//  Created by Nirav Goswami on 2022-11-11.
//

import Foundation

class ToDoItem
{
    var id:Int = 0
    var name: String = ""
    var notes: String = ""
    var hasDueDate: Bool = false
    var isCompleted: Bool = false
    var dueDate: Date = Date()
    var createdDate: Date = Date()
    
    init(id:Int, name:String, notes:String, hasDueDate:Bool, isCompleted:Bool, dueDate: Date, createdDate: Date)
    {
        self.id = id
        self.name = name
        self.notes = notes
        self.hasDueDate = hasDueDate
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.createdDate = createdDate
    }
    
}

//
//  TodoListItem.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import Foundation


struct TodoListItem: Codable, Identifiable {
    
    let id: String
    var title: String
    var description: String
    var dueDate: TimeInterval
    var category: String
    let createdDate: TimeInterval
    var completedDate: TimeInterval
    var isDone: Bool
    var isStarred: Bool
    
    
    mutating func setDone(_ state: Bool){
        isDone = state
    }
    
    mutating func setStarred(_ state: Bool){
        isStarred = state
    }
    
    // Derived status based on dueDate and isDone
    var status: TodoListItemStatus {
        if isDone {
            return .isDone
        } else if Date(timeIntervalSince1970: dueDate)
                    < Date() && !isDone
        {
            return .overdue
        } else {
            return .pending
        }
    }
    
}


enum TodoListItemStatus {
    case overdue
    case pending
    case isDone
}

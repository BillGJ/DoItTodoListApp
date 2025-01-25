//
//  TodoListCategory.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/8/25.
//

import Foundation


struct TodoListCategory: Codable, Identifiable {
    let id: String
    var name: String
//    let color: String
    let createdDate: TimeInterval
    
}

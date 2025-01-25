//
//  User.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import Foundation



struct User: Codable {
    
    let id: String
    let userName: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let joined: TimeInterval
    
}

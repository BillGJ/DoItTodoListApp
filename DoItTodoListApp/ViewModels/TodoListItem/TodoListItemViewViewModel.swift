//
//  TodoListItemViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation


/// ViewModel for a single todo list item (each row in items list)

class TodoListItemViewViewModel: ObservableObject {
    
    
    init(){}
    
    
    func truncatedText(_ text: String, maxLength: Int = AppConstants.TodoListItemTitleTruncatedMaxLength) -> String {
        if text.count > maxLength {
            let endIndex = text.index(text.startIndex, offsetBy: maxLength)
            return text[..<endIndex] + "..."
        }
        return text
    }
    
    func toggleIsDone(item: TodoListItem){
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        itemCopy.completedDate = Date().timeIntervalSince1970

        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
    
    func toggleIsStarred(item: TodoListItem){
        
        var itemCopy = item
        itemCopy.setStarred(!item.isStarred)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
    
    
    // Check if the due date is overdue
    func isOverdue(item: TodoListItem) -> Bool {
        
        let currentDate = Date()
        let dueDate = Date(timeIntervalSince1970: item.dueDate)
        
        return dueDate < currentDate && !item.isDone
    }
    
}

//
//  NewItemViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation


class NewItemViewViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var dueDate = Date()
    @Published var category = "No Category"
    @Published var isStarred : Bool = false
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var categoryArray : [String] = []
    @Published var isLoading = false

    
    
    
    
    func fetchCategories() {
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("todoCategories")
            .getDocuments { [self] categories, error in
                if let error {
                    print("Error fetching categories: \(error)")
                    return
                }
                
                guard let categoryItems = categories else {
                    return
                }
                
                categoryArray = categoryItems.documents.compactMap { document in
                    return document.data()["name"] as? String
                }
                
                categoryArray.sort()
            }
    }
    
    
    func save() {
        
        guard checkCanSave(title: title, dueDate: dueDate) else {
            return
        }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        self.isLoading = true
        
        // Create model
        let newId = UUID().uuidString
        let newItem = TodoListItem(
            id: newId,
            title: title,
            description: description,
            dueDate: dueDate.timeIntervalSince1970,
            category: category,
            createdDate: Date().timeIntervalSince1970,
            completedDate: 0,
            isDone: false,
            isStarred: isStarred
        )
        
        // Save model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(newId)
            .setData(newItem.asDictionary())
        
        self.isLoading = false

    }
    
    
    func checkCanSave(title: String, dueDate: Date) -> Bool {
        
        var canSave: Bool {
            
            guard !title.hasPrefix(" ") else {
                self.alertMessage = "Your todo item title cannot start with a space."
                return false
            }
            
            guard !title.hasSuffix(" ") else {
                self.alertMessage = "Your todo item title cannot end with a space."
                return false
            }
            
            
            guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
                self.alertMessage = "Title and due date fields are required. Please also select a due date that is today or later."
                return false
            }
            
            guard dueDate >= Date().addingTimeInterval(-86400) else {
                self.alertMessage = "Title and due date fields are required. Please also select a due date that is today or later."
                return false
            }
            
            return true
        }
        
        return canSave
    }
    
    
}

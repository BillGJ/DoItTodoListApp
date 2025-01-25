//
//  EditItemViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/13/25.
//


import FirebaseAuth
import FirebaseFirestore
import Foundation


class EditItemViewViewModel: ObservableObject {
    
    @Published var showAlert = false
    @Published var categoryArray : [String] = []
    @Published var alertMessage = ""
    @Published var itemEdited = false
    @Published var isLoading = false

    
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
    
    
    func edit(item: TodoListItem) {
        
        guard checkCanEdit(item: item) else {
            return
        }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        self.isLoading = true
        
        let updatedItem = TodoListItem (
            id: item.id,
            title: item.title,
            description: item.description,
            dueDate: item.dueDate,
            category: item.category,
            createdDate: item.createdDate,
            completedDate: item.isDone ? Date().timeIntervalSince1970 : 0,
            isDone: item.isDone,
            isStarred: item.isStarred
        )
        
        // Save model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(item.id)
            .setData(updatedItem.asDictionary())
        
        self.alertMessage = "Your todo item has been updated successfully!"
        self.isLoading = false
    }
    
  
    
    func checkCanEdit(item: TodoListItem) -> Bool {
        
        var canEdit: Bool {
            
            guard !item.title.hasPrefix(" ") else {
                self.alertMessage = "Your title cannot start with a space."
                return false
            }
            
            guard !item.title.hasSuffix(" ") else {
                self.alertMessage = "Your title cannot end with a space."
                return false
            }
            
            guard !item.title.trimmingCharacters(in: .whitespaces).isEmpty else {
                self.alertMessage = "Title and due date fields are required. Please also select a due date that is today or later."
                return false
            }
            
            guard Date(timeIntervalSince1970: item.dueDate) >= Date().addingTimeInterval(-86400) else {
                self.alertMessage = "Title and due date fields are required. Please also select a due date that is today or later."
                return false
            }
            
            return true
        }
        
        return canEdit
    }
}

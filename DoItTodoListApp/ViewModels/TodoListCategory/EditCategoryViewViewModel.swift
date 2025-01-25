//
//  EditCategoryViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/14/25.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation


class EditCategoryViewViewModel: ObservableObject {
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var categoryExists = false
    @Published var canEdit: Bool = true
    @Published var isLoading = false
    
    
    
    func restrictInputLength(_ input: String , maxWordLength: Int) -> String {
        if input.count >= maxWordLength {
            return String(input.prefix(maxWordLength))
        }
        return input
    }
    
    
    func restrictInputToLetters(_ input: String) -> String {
        return input.filter { !$0.isWhitespace && $0.isLetter && !$0.isNumber}
    }

    
    func checkCanEdit(category: TodoListCategory) -> Bool {
        
        var canEdit: Bool {
            
            guard !category.name.hasPrefix(" ") else {
                self.alertMessage = "Your category name cannot start with a space."
                return false
            }
            
            guard !category.name.hasSuffix(" ") else {
                self.alertMessage = "Your category name cannot end with a space."
                return false
            }
            
            
            guard !category.name.trimmingCharacters(in: .whitespaces).isEmpty else {
                self.alertMessage = "Please enter a category name."
                return false
            }
            
            return true
        }
        
        return canEdit
        
    }
    
    
    
    @MainActor
    func editValidCategory(category: TodoListCategory) async throws {
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        let query = try await db.collection("users")
            .document(uId)
            .collection("todoCategories")
        // convert fields to lowercase and compare (extra care)
            .whereField("name", isEqualTo: category.name).getDocuments()
        
        if !query.documents.isEmpty {
            self.categoryExists = true
            self.alertMessage = "This category already exists."
        } else {
            self.categoryExists = false
            //            await self.edit(category: category)
        }
        
    }
    
    
    @MainActor
    func edit(category: TodoListCategory) {
        
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        self.isLoading = true // Show a loading indicator

        
        // Create model
        let updatedCategory = TodoListCategory(
            id: category.id,
            name: category.name,
            createdDate: category.createdDate
        )
        
        // Save model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("todoCategories")
            .document(category.id)
            .setData(updatedCategory.asDictionary())
        
        self.isLoading = false // Hide the loading indicator
        
    }
    
    
}

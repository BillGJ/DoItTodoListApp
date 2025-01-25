//
//  NewCategoryViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/8/25.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation



class NewCategoryViewViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var color: String = ""
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    @Published var categoryExists = false
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
    
    
    var canSave: Bool {
        
        guard !name.hasPrefix(" ") else {
            self.alertMessage = "Your category name cannot start with a space."
            return false
        }
        
        guard !name.hasSuffix(" ") else {
            self.alertMessage = "Your category name cannot end with a space."
            return false
        }
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.alertMessage = "Please enter a category name."
            return false
        }
        
        return true
    }
    
    
    @MainActor
    func saveValidCategory(categoryName: String) async throws {
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        let query = try await db.collection("users")
            .document(uId)
            .collection("todoCategories")
        // convert fields to lowercase and compare (extra care)
            .whereField("name", isEqualTo: categoryName).getDocuments()
        
        if !query.documents.isEmpty {
            self.categoryExists = true
            self.alertMessage = "This category already exists."
        } else {
            self.categoryExists = false
            await self.save()
        }
        
        
    }
    
    
    @MainActor
    func save() async {
        guard canSave else {
            return
        }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        self.isLoading = true
        // Create model
        let newId = UUID().uuidString
        let newCategory = TodoListCategory(
            id: newId,
            name: name,
            createdDate: Date().timeIntervalSince1970
        )

        // Save model
        let db = Firestore.firestore()
        
        do {
            try await db.collection("users")
                .document(uId)
                .collection("todoCategories")
                .document(newId)
                .setData(newCategory.asDictionary())
            
            self.isLoading = false
            
        } catch {
            print("Error while saving new category: \(error.localizedDescription)")
            self.isLoading = false
        }
    }
}

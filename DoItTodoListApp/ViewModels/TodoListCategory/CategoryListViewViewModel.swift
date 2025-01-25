//
//  CategoryListViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/8/25.
//


import FirebaseFirestore
import Foundation


class CategoryListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    private let userId: String
    
    var category: TodoListCategory? = nil
    
    
    init(userId: String) {
        self.userId = userId
    }
    
    
    func countTodosForCategory(categoryName: String) -> Int {
        let db = Firestore.firestore()
        let todosPath = "/users/\(userId)/todos"
        var count = 0
        // Query todos for the given category name
        db.collection("users")
            .document(userId)
            .collection("todos")
            .whereField("category".lowercased(), isEqualTo: categoryName)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching todos: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No documents found in path: \(todosPath) for category: \(categoryName)")
                    return
                }
                // Debug: Log the document data for verification
                for document in documents {
                    print("Fetched document: \(document.data())")
                    count += 1
                }
                
//                count = documents.count
            }
        
        return count
    }
    
    /// Delete todo list items by category name
    ///  - Parameter name: category name
    func deleteTodosByCategoryName(name: String){
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .whereField("category", isEqualTo: name)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else { return }
                
                let batch = db.batch()
                
                // Add delete operations for each document
                for document in documents {
                    batch.deleteDocument(document.reference)
                }
                
                // Commit the batch delete
                batch.commit { err in
                    if let err {
                        print("Error deleting documents: \(err)")
                    } else {
                        print( "Successfully deleted documents")
                    }
                    
                }
                
            }
        
    }
    
    /// Delete todo list categories
    ///  - Parameter id: category  id to delete
    func delete(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("todoCategories")
            .document(id)
            .delete()
    }
}

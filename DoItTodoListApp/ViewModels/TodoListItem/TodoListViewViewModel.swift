//
//  TodoListViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation


/// VIewModel for a list of items
/// Primary Tab
class TodoListViewViewModel: ObservableObject {
    
    @Published var showingNewItemView = false
    @Published var showingItemEditView = false
    @Published private var selectedCategory: String = "All"
   
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }

    
    /// Delete todo list item
    ///  - Parameter id: item id to delete
    func delete(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(id)
            .delete()
    }
    
    
//    func filterTodoList(searchedText: String) {
//        if searchedText.isEmpty {
//            self.originalTodoListItems = self.filteredItems
//        } else {
//            self.originalTodoListItems = self.filteredItems.filter { item in
//                return item.title.localizedCaseInsensitiveContains(searchedText) || item.category.localizedCaseInsensitiveContains(searchedText)
//            }
//        }
//    }
    
}

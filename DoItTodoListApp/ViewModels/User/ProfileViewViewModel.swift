//
//  ProfileViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation


class ProfileViewViewModel: ObservableObject {
    
    @Published var user: User? = nil
    @Published var completedTasks = 0
    @Published var pendingTasks = 0
    @Published var totalTasks = 0
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    
    func fetchUser(){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument{ [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else { return }
            
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    userName: data["userName"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    phoneNumber: data["phoneNumber"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0
                )
            }
        }
       
    }
    
    
    func fetchCompletedTasks(){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).collection("todos").whereField("isDone", isEqualTo: true).getDocuments{ [weak self] snapshot, error in
            
            guard let data = snapshot, error == nil else { return }
            
            self?.completedTasks = data.documents.count
            
        }
    }
    
    
    
    
    func logOut(){
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

//
//  MainViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import FirebaseAuth
import Foundation


class MainViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    @Published var isEmailVerified: Bool = false
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener {[weak self] _, user in
            DispatchQueue.main.async {
               
//                guard let user else {
//                    return
//                }
                
                self?.currentUserId = user?.uid ?? ""
               
            }
        }
    }
    
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    

    
}

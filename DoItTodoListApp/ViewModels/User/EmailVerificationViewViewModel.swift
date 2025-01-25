//
//  EmailVerificationViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/24/25.
//

import Foundation
import FirebaseAuth



final class EmailVerificationViewViewModel : ObservableObject {
    
    @Published var alertMessage = ""
    @Published var isSendingEmailVerification: Bool = false
    @Published var isVerificationSent: Bool = false
    
    
    func sendEmailVerification() {
        guard let user = Auth.auth().currentUser else { return }
        
        self.isSendingEmailVerification = true
        
        user.sendEmailVerification { error in
            if let error = error {
                
                self.alertMessage = error.localizedDescription
            } else {
                self.isVerificationSent = true
            }
        }
        
        isSendingEmailVerification = false
    }
    
    
    func checkEmailVerification(completion: @escaping (Bool) -> Void) {
        Auth.auth().currentUser?.reload { error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                completion(false)
            } else {
                completion(Auth.auth().currentUser?.isEmailVerified ?? false)
            }
        }
    }
}

//
//  ResetPasswordViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/23/25.
//

import Foundation
import FirebaseAuth


final class ResetPasswordViewViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var alertMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    
    init(){}

    func sendPasswordReset() {
        
        guard validate() else {
            self.isError = true
            return
        }
        
        self.isLoading = true
        
        Auth.auth().sendPasswordReset(withEmail: email) { [self] error in
            if let error = error {
                handleFirebaseError(error as NSError)
//                self.alertMessage = error.localizedDescription
//                self.isError = true
            } else {
                self.alertMessage = "A password reset link has been sent to \(email)."
                self.isError = false
            }
        }
        
        self.isLoading = false
    }
    
    private func validate() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.alertMessage = "Please fill in all fields"
            return false
        }
        
        // email@bar.com
        guard email.contains("@") && email.contains(".") else {
            self.alertMessage = "Please enter a valid email"
            return false
        }
        
        return true
    }
    
    
    // Handle Firebase errors for password reset
        private func handleFirebaseError(_ error: NSError) {
            switch error.code {
            case AuthErrorCode.userNotFound.rawValue:
                self.alertMessage = "This email address is not registered."
            case AuthErrorCode.invalidEmail.rawValue:
                self.alertMessage = "This email address is invalid."
            case AuthErrorCode.invalidRecipientEmail.rawValue:
                  // Error: Indicates an invalid recipient email was sent in the request.
                self.alertMessage = "Invalid recipient email."
            default:
                 print(error.localizedDescription)
            }
            self.isError = true
        }
}

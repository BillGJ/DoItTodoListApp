//
//  LoginViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import Foundation
import FirebaseAuth


class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var alertMessage = ""
    @Published var isLoading = false
    @Published var isEmailVerified: Bool = false

    @Published var isSendingEmailVerification: Bool = false
    @Published var isVerificationSent: Bool = false
    
    
    init() {}
    
    func login() {
        
        guard validate() else { return }
        
        isLoading = true
        // Try logging in
        
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] user, error in
            
            if let error = error as? NSError {
                
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                    self?.alertMessage = "Email and password accounts are not enabled. Please contact an administrator for assistance."
                case .userDisabled:
                    // Error: The user account has been disabled by an administrator.
                    self?.alertMessage = "The user account has been disabled by an administrator."
                case .wrongPassword:
                    // Error: The password is invalid or the user does not have a password.
                    self?.alertMessage = "The password is invalid."
                    //                case .invalidEmail:
                    //                  // Error: Indicates the email address is malformed.
                default:
                    print("Error: \(error.localizedDescription)")
                    self?.alertMessage = "Invalid credentials."
                }
                
                self?.isLoading = false
                
            } else {
                
//                self?.checkEmailVerification { verified in
//                    self?.isEmailVerified = verified
//                }
//                
//                guard let emailVerified = self?.isEmailVerified else {
//                    return
//                }
//                
//                if !emailVerified {
//                    self?.sendEmailVerification()
//                    self?.alertMessage = "A verification email has been sent to your email address."
//                }
//                print("User signs in successfully")
                self?.isLoading = false
//                let userInfo = Auth.auth().currentUser
//                let email = userInfo?.email
            }
            
        }
        
    }
    
    
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
    
    
    private func validate() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please fill in all fields"
            return false
        }
        
        // email@bar.com
        guard email.contains("@") && email.contains(".") else {
            alertMessage = "Please enter a valid email"
            return false
        }
        
        return true
    }
}

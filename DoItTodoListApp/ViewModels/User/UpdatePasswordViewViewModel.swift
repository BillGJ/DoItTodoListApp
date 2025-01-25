//
//  UpdatePasswordViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/23/25.
//

import Foundation
import FirebaseAuth



final class UpdatePasswordViewViewModel: ObservableObject {
    
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var alertMessage: String = ""
    @Published var isError: Bool = false
    @Published var isLoading: Bool = false
    
    // Function to validate and update the password
    
    @MainActor
    func updatePassword() async {
        guard validateInput() else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            
            try await reauthenticateUser()
            try await Auth.auth().currentUser?.updatePassword(to: newPassword)
            alertMessage = "Password updated successfully."
            isError = false
            
            // Clear all fields
            
            currentPassword = ""
            newPassword = ""
            confirmPassword = ""
            
        } catch let error as NSError {
            handleError(error)
        }
    }
    
    // Validate the input fields
    private func validateInput() -> Bool {
        
        guard !currentPassword.trimmingCharacters(in: .whitespaces).isEmpty,
                !newPassword.trimmingCharacters(in: .whitespaces).isEmpty,
                !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.alertMessage = "Please fill in all fields."
            self.isError = true
            return false
        }
        
        guard currentPassword != newPassword else {
            self.alertMessage = "New password should not match old password."
            self.isError = true
            return false
        }
        
        guard newPassword == confirmPassword else {
            self.alertMessage = "New password and confirmation do not match."
            self.isError = true
            return false
        }
        
        guard newPassword.count >= 6 else {
            self.alertMessage = "Password must be at least 6 characters long."
            self.isError = true
            return false
        }
        
        return true
    }
    
    // Reauthenticate the user using async/await
    private func reauthenticateUser() async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            throw NSError(domain: "FirebaseAuth", code: AuthErrorCode.requiresRecentLogin.rawValue, userInfo: [NSLocalizedDescriptionKey: "Unable to reauthenticate. Please log in again."])
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        try await user.reauthenticate(with: credential)
    }
    
    // Handle Firebase errors
    private func handleError(_ error: NSError) {

        switch error.code {
        case AuthErrorCode.wrongPassword.rawValue:
            self.alertMessage = "The current password is incorrect."
        case AuthErrorCode.weakPassword.rawValue:
            self.alertMessage = "The new password is too weak. Try a stronger password."
        case AuthErrorCode.requiresRecentLogin.rawValue:
            self.alertMessage = "Please log in again to update your password."
        default:
            self.alertMessage = error.localizedDescription
        }
       
        self.isError = true
    }
}

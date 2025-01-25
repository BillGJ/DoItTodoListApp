//
//  RegisterViewViewModel.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation


@MainActor
class RegisterViewViewModel: ObservableObject {
    
    @Published var userName = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var phoneNumber = ""
    
    @Published var alertMessage = ""
    @Published var isLoading = false
    @Published var isRegistrationSuccessful = false
    @Published var isSendingEmailVerification: Bool = false
    @Published var isVerificationSent: Bool = false
    @Published var verificationCode: String = ""
    @Published var verificationID: String? = nil
    
    
    let predefinedCategories = [
        TodoListCategory(id:UUID().uuidString,name: "No Category", createdDate: Date().timeIntervalSince1970),
        TodoListCategory(id:UUID().uuidString,name: "All", createdDate: Date().timeIntervalSince1970),
        TodoListCategory(id:UUID().uuidString,name: "Work", createdDate: Date().timeIntervalSince1970),
        TodoListCategory(id:UUID().uuidString,name: "Personal", createdDate: Date().timeIntervalSince1970),
        TodoListCategory(id:UUID().uuidString,name: "Birthday", createdDate: Date().timeIntervalSince1970),
        TodoListCategory(id:UUID().uuidString,name: "Wishlist", createdDate: Date().timeIntervalSince1970),
        TodoListCategory(id:UUID().uuidString,name: "Shopping", createdDate: Date().timeIntervalSince1970),
        TodoListCategory(id:UUID().uuidString,name: "Other", createdDate: Date().timeIntervalSince1970),
    ]
    
    
    init() {}
    
    
    func prefillTodoCategories() {
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        // loop over predefinedCategories to save them
        for category in predefinedCategories {
            db.collection("users")
                .document(uId)
                .collection("todoCategories")
                .document(category.id)
                .setData(category.asDictionary())
        }
    }
    
    
    func register() async {
        
        guard validate() else { return }
        
        do {
            self.isLoading = true // Show a loading indicator
            
            try await registerValidAccount()
            
        }catch {
            print("Error: \(error.localizedDescription)")
            self.isLoading = false // Hide the loading indicator
            
        }
        
    }
    
    
    private func registerValidAccount() async throws {
        
        let db = Firestore.firestore()
        
        
        // Check if username or phone are already taken
        let queries = try await [
            db.collection("users").whereField("userName", isEqualTo: userName.lowercased()).getDocuments(), // convert fields to lowercase and compare (extra care)
            db.collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments()
        ]
        
        // Perform all queries concurrently
        Task {
            do {
                let results = try await withThrowingTaskGroup(of: QuerySnapshot.self) { group -> [QuerySnapshot] in
                    for query in queries {
                        group.addTask { query }
                    }
                    
                    var snapshots: [QuerySnapshot] = []
                    for try await snapshot in group {
                        snapshots.append(snapshot)
                    }
                    return snapshots
                }
                
                // Process results
                if !results[0].documents.isEmpty {
                    self.alertMessage = "The username is already taken."
                } else if !results[1].documents.isEmpty {
                    self.alertMessage = "The phone number is already registered."
                } else {
                    // If all fields are unique, proceed with registration
                    self.createUser()
                    self.isRegistrationSuccessful = true
                }
                
            } catch {
                alertMessage = "An error occurred. Please try again."
                self.isLoading = false // Hide the loading indicator
                
            }
            
            // Stop the loading indicator
            self.isLoading = false
        }
        
    }
    
    
    private func createUser(){
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            
            if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                    self?.alertMessage = "The given sign-in provider is disabled. Please contact an administrator for assistance."
                    
                case .emailAlreadyInUse:
                    // Error: The email address is already in use by another account.
                    self?.alertMessage = "The email address is already in use."
                    //                case .invalidEmail:
                    //                    // Error: The email address is badly formatted.
                    //                    self?.errorMessage = "The email address is badly formatted."
                    //                case .weakPassword:
                    //                    // Error: The password must be 6 characters long or more.
                default:
                    print("Error: \(error.localizedDescription)")
                }
                
                return
            } else {
                guard let userId = result?.user.uid else { return }
                
//                guard let user = result?.user else { return }
//
//                if !user.isEmailVerified {
//                    self?.sendEmailVerification()
//                } else {
//                    self?.alertMessage = "Email is already verified."
//                }
                
//                self?.sendPhoneVerification()
                
                // Registering new user
                self?.insertUserRecord(id: userId)
                
                // Prefill Todo Categories after registering new user
                self?.prefillTodoCategories()
            }
        }
    }
    
    
    private func insertUserRecord(id: String) {
        let newUser = User(
            id: id, userName: userName.lowercased(), // username must be in lowercase
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            joined: Date().timeIntervalSince1970
        )
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
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
    
    
    func sendPhoneVerification() {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                return
            }
            self.verificationID = verificationID
        }
    }
    
    
    func verifyCode() {
        guard let verificationID = verificationID else {
            self.alertMessage = "Verification ID not found."
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                self.alertMessage = "Phone number verified successfully!"
            }
        }
    }
    
    
    func validate() -> Bool{
        
        self.isLoading = true // Show a loading indicator
        
        guard !userName.trimmingCharacters(in: .whitespaces).isEmpty,
              !firstName.trimmingCharacters(in: .whitespaces).isEmpty,
              !lastName.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            self.alertMessage = "Please fill in all fields"
            self.isLoading = false
            
            return false
        }
        
        guard userName.count >= 4 else {
            
            alertMessage = "Username must be at least 4 characters long"
            self.isLoading = false
            
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            
            alertMessage = "Invalid email"
            self.isLoading = false
            
            return false
        }
        
        guard password.count >= 6 else {
            
            alertMessage = "Password must be at least 6 characters long"
            self.isLoading = false
            
            return false
        }
        
        guard phoneNumber.starts(with: "+") else {
            
            alertMessage = "Phone number must be in international format (starting with +)"
            self.isLoading = false
            
            return false
        }
        
        self.isLoading = false
        
        return true
    }
    
    
    
    
    
}

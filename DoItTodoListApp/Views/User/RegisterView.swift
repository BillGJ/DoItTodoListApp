//
//  RegisterView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import SwiftUI
import iPhoneNumberField

struct RegisterView: View {
    
    @StateObject var registerViewModel = RegisterViewViewModel()
    @State private var isUsernameAvailable: Bool?
    @State private var isChecking: Bool = false // Indicator for ongoing checks
    
    var body: some View {
        VStack {
            // Header
            HeaderView(title: "Register", subtitle: "Start organizing Todos", angle: -15, background: .yellow)
            
            Form {
                
               
                
//                if isChecking {
//                    Text("Checking...").foregroundColor(.gray)
//                } else if let isAvailable = isUsernameAvailable {
//                    Text(isAvailable ? "✅ Username is available" : "❌ Username is already taken")
//                        .foregroundColor(isAvailable ? .green : .red)
//                }
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 18)) // Icon size
                    TextField("Username", text: $registerViewModel.userName)
                        .accentColor(.red)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)

                }
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 18)) // Icon size
                    TextField("First Name", text: $registerViewModel.firstName)
                        .accentColor(.red)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                }
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 18)) // Icon size
                    TextField("Last Name", text: $registerViewModel.lastName)
                        .accentColor(.red)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                }
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 12)) // Set icon size
                    
                    TextField("Email Address", text: $registerViewModel.email)
                        .accentColor(.red)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 18)) // Set icon size
                    
                    SecureField("Password", text: $registerViewModel.password)
                        .accentColor(.red)
                        .textFieldStyle(DefaultTextFieldStyle())
                }
                
                iPhoneNumberField("Phone", text: $registerViewModel.phoneNumber)
                    .flagHidden(false)
                    .flagSelectable(true)
                    .prefixHidden(false)
                    .accentColor(.red)

                
                if registerViewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Registering new user...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                            .padding()
                        Spacer()
                    }
                } else {
                    if !registerViewModel.alertMessage.isEmpty {
                        Text("❌ \(registerViewModel.alertMessage)")
                            .foregroundColor(Color.red)
                    }
                    
                    DITLButton(title: "Create Account", background: .green){
                        // Attempt registration
                        Task {
                            await registerViewModel.register()
                        }
                    }
                    .padding()
                    
                }
            }
            .offset(y: -50)
            
            Spacer()
        }
    }
    
    
    // ViewModel Firestore query function
//    private func checkUsernameAvailability() {
//        guard !registerViewModel.userName.isEmpty else {
//            isUsernameAvailable = nil // Reset state when input is empty
//            return
//        }
//        
//        isChecking = true // Show checking state
//        
//        registerViewModel.checkIfUsernameExists(userName: registerViewModel.userName) { exists in
//            DispatchQueue.main.async {
//                isUsernameAvailable = !exists // Update availability
//                isChecking = false // Hide checking state
//            }
//        }
//    }
}

#Preview {
    RegisterView()
}

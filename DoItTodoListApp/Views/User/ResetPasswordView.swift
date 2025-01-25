//
//  ResetPasswordView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/23/25.
//

import SwiftUI


struct ResetPasswordView: View {
    @StateObject var resetPasswordViewModel = ResetPasswordViewViewModel()
    

    var body: some View {
        
        VStack {
            
            // Header
            HeaderView(title: "Do It - Todo List", subtitle: "Just Go For It!", angle: 15, background: .blue)
            
            // Form
            Form {
                HStack {
                    Text("Reset Password")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    Spacer()
                }
                
                HStack {
                    
                    Text("Enter your email address, and we'll send you a link to reset your password.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 12)) // Set icon size
                    
                    TextField("Email Address", text: $resetPasswordViewModel.email)
                        .accentColor(.red)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                
                if !resetPasswordViewModel.alertMessage.isEmpty {
                    Text(resetPasswordViewModel.alertMessage)
                        .foregroundColor(resetPasswordViewModel.isError ? .red : .green)
                }
                
                
                if resetPasswordViewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Sending reset password link...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                            .padding()
                        Spacer()
                    }
                } else {
                    DITLButton(title: "Send Password Reset Link", background: .green){
                        // Attempt sending link
                        resetPasswordViewModel.sendPasswordReset()
                    }
                    .padding()
                    .disabled(resetPasswordViewModel.isLoading)
                }
            }
            .offset(y: -50)
            Spacer()

        }
        
    }

    
}


#Preview {
    ResetPasswordView()
}


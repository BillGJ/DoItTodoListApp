//
//  UpdatePasswordView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/23/25.
//

import SwiftUI

struct UpdatePasswordView: View {
    @StateObject var updatePasswordViewModel = UpdatePasswordViewViewModel()
    
    var body: some View {
//        VStack(spacing: 20) {
        VStack {
            // Header
            HeaderView(title: "Do It - Todo List", subtitle: "Just Go For It!", angle: 15, background: .blue)
            
            // Form
            Form {
                
                Text("Update Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 18)) // Set icon size
                    SecureField("Current Password", text: $updatePasswordViewModel.currentPassword)
                        .accentColor(.red)
                        .textFieldStyle(DefaultTextFieldStyle())
                }
                
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 18)) // Set icon size
                    SecureField("New Password", text: $updatePasswordViewModel.newPassword)
                        .accentColor(.red)
                        .textFieldStyle(DefaultTextFieldStyle())
                }
                
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 18)) // Set icon size
                    SecureField("Confirm New Password", text: $updatePasswordViewModel.confirmPassword)
                        .accentColor(.red)
                        .textFieldStyle(DefaultTextFieldStyle())
                }
                
                if !updatePasswordViewModel.alertMessage.isEmpty {
                    Text(updatePasswordViewModel.alertMessage)
                        .foregroundColor(updatePasswordViewModel.isError ? .red : .green)
                }
                
                Button(action: {
                    Task {
                        await updatePasswordViewModel.updatePassword()
                    }
                }) {
                    if updatePasswordViewModel.isLoading {
                        
                        HStack {
                            Spacer()
                            ProgressView("Updating password...")
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                                .padding()
                            Spacer()
                        }
                    } else {
                        Text("Update Password")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .disabled(updatePasswordViewModel.isLoading)
                .padding(.horizontal)
                
               
            }
            .offset(y: -70)
            
            Spacer()

        }
        .accentColor(.red)
    }
    
    
}



#Preview {
    UpdatePasswordView()
}

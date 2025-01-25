//
//  LoginView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginViewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationView {
            
            VStack {
                // Header
                HeaderView(title: "Do It - Todo List", subtitle: "Just Go For It!", angle: 15, background: .red)
                
                // Login Form
                Form {
                    
                    HStack{
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 12)) // Set icon size

                        TextField("Email Address", text: $loginViewModel.email)
                            .accentColor(.red)
                            .keyboardType(.emailAddress)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    
                    HStack {
                        Image(systemName: "lock.fill")
                                           .foregroundColor(.gray)
                                           .font(.system(size: 18)) // Set icon size
                        
                        SecureField("Password", text: $loginViewModel.password)
                            .accentColor(.red)
                            .textFieldStyle(DefaultTextFieldStyle())
                    }
                    
                    if !loginViewModel.alertMessage.isEmpty {
                        Text(loginViewModel.alertMessage)
                            .foregroundColor(Color.red)
                    }
                    
                    if loginViewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView("Logging in...")
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                                .padding()
                            Spacer()
                        }
                    } else {
                        
                        DITLButton(title: "Login", background: .blue){
                            // Attempt to log in
                            loginViewModel.login()
                        }
                        .disabled(loginViewModel.isLoading)
                        .padding()
                    }
                }
                .offset(y: -80)
                
                // Create Account
                VStack {
                    Text("New around here?")
                    NavigationLink ("Create An Account", destination: RegisterView())
                        .accentColor(.blue)
                }
                .padding(.bottom, 20)
                
                VStack {
                    Text("Forgot your password?")
                    NavigationLink ("Reset your password", destination: ResetPasswordView())
                        .accentColor(.blue)
                }
                .padding(.bottom, 20)
                Spacer()
                
            }
        }
        .accentColor(.white)
    }
}

#Preview {
    LoginView()
}

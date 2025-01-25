//
//  EmailVerificationView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/24/25.
//

import SwiftUI

struct EmailVerificationView: View {
    
    @StateObject var emailVerificationViewModel = EmailVerificationViewViewModel()
    
    
//    init(isCurrentUserEmailVerified: Bool){
//        
//        self._emailVerificationViewModel = StateObject(
//            wrappedValue: EmailVerificationViewViewModel(isCurrentUserEmailVerified: isCurrentUserEmailVerified)
//        )
//    }
//    
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                // Header
                HeaderView(title: "Do It - Todo List", subtitle: "Just Go For It!", angle: 15, background: .blue)
                
                // Form
                Form {
                    HStack {
                        Text("Verify Email")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    //                if !registerViewModel.alertMessage.isEmpty {
                    //                    Text(registerViewModel.alertMessage)
                    //                        .foregroundColor(registerViewModel.isError ? .red : .green)
                    //                }
                    
                    if emailVerificationViewModel.isVerificationSent {
                        Text("Verification email sent. Please check your inbox.")
                            .foregroundColor(.green)
                    }
                    
                    if !emailVerificationViewModel.alertMessage.isEmpty {
                        Text(emailVerificationViewModel.alertMessage)
                            .foregroundColor(.red)
                    }
                    
                    NavigationLink("Back to login", destination: LoginView())
                        .foregroundColor(.blue)
                        .accentColor(.blue)
//                    {
//                        Text("Back to login")
//                            .fontWeight(.bold)
//                            .frame(maxWidth: .infinity, minHeight: 50)
//                            .foregroundColor(.white)
//                            .background(Color.blue)
//                            .cornerRadius(15)
//                    }
                    .padding(.horizontal, 16)
                    
                    if emailVerificationViewModel.isSendingEmailVerification {
                        HStack {
                            Spacer()
                            ProgressView("Sending verification email...")
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                                .padding()
                            Spacer()
                        }
                    } else {
                        
                        
                        DITLButton(title: "Resend Verification Email", background: .green){
                            // Attempt sending link
                            emailVerificationViewModel.sendEmailVerification()
                        }
                        .padding()
                        .disabled(emailVerificationViewModel.isSendingEmailVerification)
                    }
                }
            }
        }
    }
}

#Preview {
//    EmailVerificationView(isCurrentUserEmailVerified: true)
    EmailVerificationView()
}

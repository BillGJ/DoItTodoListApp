//
//  MainView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainViewModel = MainViewViewModel()
    
    
    var body: some View {
        
        if mainViewModel.isSignedIn,
           !mainViewModel.currentUserId.isEmpty
        {
            // Signed In
            accountView
           
            
//        } else if mainViewModel.isSignedIn,
//                  !mainViewModel.currentUserId.isEmpty,
//                  !mainViewModel.isEmailVerified
//        {
//            EmailVerificationView()
        } else {
            LoginView()
        }
    }
    
    
    @ViewBuilder
    var accountView: some View {
        TabView {
            TodoListView(userId: mainViewModel.currentUserId)
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            CategoryListView(userId: mainViewModel.currentUserId)
                .tabItem {
                    Label("Categories", systemImage: "list.bullet.rectangle")
                }
            StarredTodoListView(userId: mainViewModel.currentUserId)
                .tabItem {
                    Label("Starred", systemImage: "star")
                }
            
            PastTodoListView(userId: mainViewModel.currentUserId)
                .tabItem {
                    Label("Past", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                }
            
            ProfileView(userId: mainViewModel.currentUserId)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .accentColor(Color.red)
    }
}

#Preview {
    MainView()
}

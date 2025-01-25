//
//  ProfileView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import FirebaseFirestore
import SwiftUI

struct ProfileView: View {
    
    @StateObject var profileViewModel : ProfileViewViewModel
   
    @FirestoreQuery var items: [TodoListItem]

    
    init(userId: String){
        //        self.userId = userId
        // users/<id>/todos/<entries>
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos",
                                     predicates: [.order(by: "dueDate")]
        )
        self._profileViewModel = StateObject(wrappedValue: ProfileViewViewModel(userId: userId))

    }
    
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    if let user = profileViewModel.user {
                        
                        profile(user: user)
                        
                    } else {
                        
                        HStack {
                            Spacer()
                            ProgressView("Loading Profile...")
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                                .padding()
                            Spacer()
                        }
                        
                        Button("Log Out") {
                            profileViewModel.logOut()
                        }
                        .tint(.red)
                        .padding()
                    }
                    
                }
                .padding()
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.large)
                .background(Color(.systemGroupedBackground))
            }
            
        }
        .accentColor(.white)
        .onAppear {
            profileViewModel.fetchUser()
        }
    }
    
    
    
    @ViewBuilder
    func profile(user: User) -> some View {
        
        VStack(spacing: 10) {
            
            // Profile Info Card
            profileInfoCard(user: user)
            
            // Task Statistics Card
            todayTodosStatsCard(user: user)
            
            Spacer()
            
            NavigationLink(destination: UpdatePasswordView()) {
                Text("Update Password")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 16)

                        
            // Logout Button
            Button(action: {
                // Handling logout action here
                profileViewModel.logOut()
            }) {
                Text("Log Out")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 16)
        }
        
    }
    
    @ViewBuilder
    func profileInfoCard(user: User) -> some View {

        VStack(spacing: 10) {
            // User Avatar
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 125, height: 125)
                .foregroundColor(.blue)
            
            // User UserName
            Text("@\(user.userName.lowercased())") // lower to make sure username are displayed in one format
                .font(.title3)
                .foregroundColor(.gray)
            
            // User First Name and Last Name
            Text("\(user.firstName) \(user.lastName.uppercased())")
                .font(.title2)
                .fontWeight(.semibold)
            
            // User Email
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // User Email
            Text(user.phoneNumber)
                .font(.subheadline)
                .foregroundColor(.gray)
    
            Divider()
            
            Text("Member Since: ")
                .font(.subheadline)
                .fontWeight(.semibold)
            Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                .font(.subheadline)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
    }
    
    
    @ViewBuilder
    func todayTodosStatsCard(user: User) -> some View {
        
        var todayItems: [TodoListItem] {
            let calendar = Calendar.current
            let todayStart = calendar.startOfDay(for: Date())
            let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)!
            
            return items.filter { item in
                Date(timeIntervalSince1970: item.dueDate) >= todayStart &&
                Date(timeIntervalSince1970: item.dueDate) < todayEnd
            }
        }
        
        let completedTodosToday: Int = todayItems.filter{ $0.isDone}.count
        let pendingTodosToday: Int = todayItems.filter { $0.status == .pending }.count
        let overdueTodosToday: Int = todayItems.filter { $0.status == .overdue }.count
//        let totalTodosToday: Int = completedTodosToday + pendingTodosToday
        
        VStack(spacing: 15) {
            Text("Today's Todos Stats")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            HStack {
                VStack {
                    Text("\(completedTodosToday)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Completed")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack {
                    Text("\(pendingTodosToday)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("Pending")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                VStack {
                    Text("\(overdueTodosToday)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("Overdue")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 30)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileView(userId: "")
}

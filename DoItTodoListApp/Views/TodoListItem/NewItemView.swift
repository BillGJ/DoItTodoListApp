//
//  NewItemView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import FirebaseFirestore
import SwiftUI

struct NewItemView: View {
    @StateObject var newItemViewModel = NewItemViewViewModel()
    @Binding var newItemPresented : Bool
    
    var body: some View {
        VStack {
            Text("New Item")
                .font(.system(size: 32))
                .foregroundColor(.red)
                .bold()
                .padding(.top, 50)
            
            Form {
                // Todo Category => Picker
                Picker("Category", selection: $newItemViewModel.category) {
                    ForEach(newItemViewModel.categoryArray, id: \.self) { category in
                        if category != "All" {
                            Text(category).tag(category)
                        }
                    }
                }
                .onAppear {
                    newItemViewModel.fetchCategories()
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .frame(maxWidth:.infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                }
                
                
                // Title
                TextField("Title", text: $newItemViewModel.title, axis: .vertical)
                    .onChange(of: newItemViewModel.title){ newValue, oldValue in
                        
                        if oldValue.count > AppConstants.TodoListItemTitleMaxLength {
                            newItemViewModel.title = String(newValue.prefix(AppConstants.TodoListItemTitleMaxLength))
                        }
                    }
                    .lineLimit(2)
                
                
                Text("Title length: \(newItemViewModel.title.count)/\(AppConstants.TodoListItemTitleMaxLength)")
                    .font(.footnote)
                    .foregroundColor(newItemViewModel.title.count == AppConstants.TodoListItemTitleMaxLength ? .red : .gray)
                    .animation(.easeInOut, value: newItemViewModel.title.count)
                
                
                if newItemViewModel.description.isEmpty {
                    Text("Description")
                        .foregroundColor(.gray)
                }
                
                TextEditor(text: $newItemViewModel.description)
                    .onChange(of: newItemViewModel.description) { oldValue, newValue in
                        
                        if oldValue.count > AppConstants.TodoListItemDescriptionMaxLength {
                            newItemViewModel.description = String(newValue.prefix(AppConstants.TodoListItemDescriptionMaxLength))
                        }
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .frame(height: 150)
                
                // Display remaining characters
                Text("Description length: \(newItemViewModel.description.count)/\(AppConstants.TodoListItemDescriptionMaxLength)")
                    .font(.footnote)
                    .foregroundColor(newItemViewModel.description.count == AppConstants.TodoListItemDescriptionMaxLength ? .red : .gray)
                    .animation(.easeInOut, value: newItemViewModel.description.count)
                
                
                // Starred Toggle
                Toggle( isOn: $newItemViewModel.isStarred){
                    Text(newItemViewModel.isStarred ? "Unstar" : "Star")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                
                // Due Date
                DatePicker("Due Date", selection: $newItemViewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                
                    .toggleStyle(SwitchToggleStyle(tint: newItemViewModel.isStarred ? .green : .red))
                
                if newItemViewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Adding new todo...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                            .padding()
                        Spacer()
                    }
                } else {
                    // Button
                    DITLButton(title: "Save", background: .red){
                        
                        if newItemViewModel.checkCanSave(title: newItemViewModel.title, dueDate: newItemViewModel.dueDate){
                            
                            newItemViewModel.save()
                            newItemPresented = false
                            
                        } else {
                            
                            newItemViewModel.showAlert = true
                            
                        }
                        
                    }
                    .disabled(newItemViewModel.isLoading)
                    .padding()
                }
            }
            .alert(isPresented: $newItemViewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(newItemViewModel.alertMessage)
                )
            }
        }
    }
    
}

#Preview {
    NewItemView(
        newItemPresented: Binding(get: {
            return true
        }, set: { _ in
            
        })
    )
    
}

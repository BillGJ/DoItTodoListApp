//
//  NewCategoryView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/8/25.
//

import SwiftUI

struct NewCategoryView: View {
    @StateObject var newCategoryViewModel = NewCategoryViewViewModel()
    @Binding var newItemPresented : Bool
    
    
    var body: some View {
        VStack {
            Text("New Category")
                .font(.system(size: 32))
                .foregroundStyle(.red)
                .bold()
                .padding(.top, 50)
            
            Form {
                // Name
                TextField("Name", text: $newCategoryViewModel.name)
                    .onChange(of: newCategoryViewModel.name) { oldValue, newValue in
                        
//                        newCategoryViewModel.name = newValue.filter { !$0.isWhitespace && $0.isLetter && !$0.isNumber }
                      
                        if oldValue.count >= AppConstants.CategoryNameMaxLength {
                            newCategoryViewModel.name = String(newValue.prefix(AppConstants.CategoryNameMaxLength))
                        }
                    }
                
                Text("Category name Length: \(newCategoryViewModel.name.count)/\(AppConstants.CategoryNameMaxLength)")
                    .font(.footnote)
                    .foregroundColor(newCategoryViewModel.name.count >= AppConstants.CategoryNameMaxLength ? .red : .gray)
                    .animation(.easeInOut, value: newCategoryViewModel.name.count)
                
                // Button
                if newCategoryViewModel.isLoading {
                    
                    HStack {
                        Spacer()
                        ProgressView("Adding new category...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                            .padding()
                        Spacer()
                    }
                    
                } else {
                    
                    DITLButton(title: "Save", background: .red){
                        Task {
                            if newCategoryViewModel.canSave {
                                
                                try await newCategoryViewModel.saveValidCategory(categoryName: newCategoryViewModel.name)
                                
                                if !newCategoryViewModel.categoryExists {
                                    newItemPresented = false
                                }else {
                                    newCategoryViewModel.showAlert = true
                                }
                                
                            } else {
                                newCategoryViewModel.showAlert = true
                            }
                        }
                        
                    }
                    .disabled(newCategoryViewModel.isLoading)
                    .padding()
                    
                }
            }
            .alert(isPresented: $newCategoryViewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("\(newCategoryViewModel.alertMessage)")
                )
            }
        }
    }
    
    
}

#Preview {
    NewCategoryView(newItemPresented: Binding(get: {
        return true
    }, set: { _ in
        
    }))}

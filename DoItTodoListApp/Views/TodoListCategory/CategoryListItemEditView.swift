//
//  CategoryListItemEditView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/14/25.
//

import SwiftUI
//import Combine


struct CategoryListItemEditView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var editCategoryViewModel : EditCategoryViewViewModel
    @State var category: TodoListCategory
    
    
    init(category: TodoListCategory){
        self._category = State(wrappedValue: category)
        //        self._item = State(initialValue: item)
        //        self._itemEditIsPresented = itemEditIsPresented
        self._editCategoryViewModel = StateObject(wrappedValue: EditCategoryViewViewModel())
    }
    
    
    
    var body: some View {
        VStack {
            Text("Edit Category")
                .font(.system(size: 32))
                .foregroundStyle(.red)
                .bold()
                .padding(.top, 50)
            
            Form {
                // Name
                TextField("Name", text: $category.name)
                    .onChange(of: category.name) { oldValue, newValue in

//                        category.name = newValue.filter { !$0.isWhitespace && $0.isLetter && !$0.isNumber }
                        
                        if oldValue.count > AppConstants.CategoryNameMaxLength {
                            category.name = String(newValue.prefix(AppConstants.CategoryNameMaxLength))
                        }
                    }
                
                Text("Category name length: \(category.name.count)/\(AppConstants.CategoryNameMaxLength)")
                    .font(.footnote)
                    .foregroundColor(category.name.count == AppConstants.CategoryNameMaxLength ? .red : .gray)
                    .animation(.easeInOut, value: category.name.count)
            
                
                if editCategoryViewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Editing category...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                            .padding()
                        Spacer()
                    }
                } else {
                    
                    // Button
                    DITLButton(title: "Save", background: .red){
                        
                        if editCategoryViewModel.checkCanEdit(category: category) {
                            editCategoryViewModel.edit(category: category )
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            editCategoryViewModel.showAlert = true
                        }
                        
                    }
                    .disabled(editCategoryViewModel.isLoading)
                    .padding()
                }
                
                
                
            }
            .alert(isPresented: $editCategoryViewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("\(editCategoryViewModel.alertMessage)")
                )
            }
        }
    }
    
    
}

#Preview {
    CategoryListItemEditView(
        category: .init(
            id: "",
            name: "Test Category",
            createdDate: Date().timeIntervalSince1970
        )
    )
}

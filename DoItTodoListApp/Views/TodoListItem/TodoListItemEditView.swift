//
//  TodoListItemEditView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/13/25.
//

import SwiftUI

struct TodoListItemEditView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var editItemViewModel : EditItemViewViewModel
    @State var item: TodoListItem
    @State var selectedDate: Date
    
    init(item: TodoListItem){
        self._item = State(wrappedValue: item)
        //        self._item = State(initialValue: item)
        //        self._itemEditIsPresented = itemEditIsPresented
        self._editItemViewModel = StateObject(wrappedValue: EditItemViewViewModel())
        self._selectedDate = State(initialValue: Date(timeIntervalSince1970: item.dueDate))
    }
    
    
    var body: some View {
        VStack {
            Text("Edit Item")
                .font(.system(size: 32))
                .foregroundColor(.red)
                .bold()
                .padding(.top, 50)
            
            Form {
                // Todo Category => Picker
                Picker("Category", selection: $item.category) {
                    ForEach(editItemViewModel.categoryArray, id: \.self) { category in
                        if category != "All" {
                            Text(category).tag(category)
                        }
                    }
                }
                .onAppear {
                    editItemViewModel.fetchCategories()
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
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    TextField("Title", text: $item.title, axis: .vertical)
                        .lineLimit(2)
                        .onChange(of: item.title){ newValue, oldValue in
                            
                            if oldValue.count > AppConstants.TodoListItemTitleMaxLength {
                                item.title = String(newValue.prefix(AppConstants.TodoListItemTitleMaxLength))
                            }
                        }
                    
                    Text("Title length: \(item.title.count)/\(AppConstants.TodoListItemTitleMaxLength)")
                        .font(.footnote)
                        .foregroundColor(item.title.count == AppConstants.TodoListItemTitleMaxLength ? .red : .gray)
                        .animation(.easeInOut, value: item.title.count)
                }
                
                // Todo Description
                
                if item.description.isEmpty {
                    Text("Description")
                        .foregroundColor(.gray)
                }
                
                TextEditor(text: $item.description)
                    .onChange(of: item.description) { oldValue, newValue in
                        
                        if oldValue.count > AppConstants.TodoListItemDescriptionMaxLength {
                            item.description = String(newValue.prefix(AppConstants.TodoListItemDescriptionMaxLength))
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
                Text("Description length: \(item.description.count)/\(AppConstants.TodoListItemDescriptionMaxLength)")
                    .font(.footnote)
                    .foregroundColor(item.description.count == AppConstants.TodoListItemDescriptionMaxLength ? .red : .gray)
                    .animation(.easeInOut, value: item.description.count)
                
                
                // Completed Toggle
                Toggle( isOn: $item.isDone){
                    Text(item.isDone ? "Mark Uncomplete" : "Mark as Completed")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                .toggleStyle(SwitchToggleStyle(tint: item.isDone ? .green : .red))
                
                // Starred Toggle
                Toggle( isOn: $item.isStarred){
                    Text(item.isStarred ? "Unstar" : "Star")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                .toggleStyle(SwitchToggleStyle(tint: item.isStarred ? .green : .red))
                
                // Due Date
                VStack(alignment: .leading) {
                    Text("Due Date")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    DatePicker("Due Date", selection: $selectedDate)
                        .onChange(of: selectedDate) {
                            item.dueDate = selectedDate.timeIntervalSince1970
                        }
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                    
                }
                
                
                //                displayAlertMessage()
                if editItemViewModel.isLoading{
                    HStack {
                        Spacer()
                        ProgressView("Editing todo...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                            .padding()
                        Spacer()
                    }
                } else {
                    // Button
                    DITLButton(title: "Save", background: .red){
                        if editItemViewModel.checkCanEdit(item: item) {
                            editItemViewModel.edit(item: item)
                            self.presentationMode.wrappedValue.dismiss()
                            
                        } else {
                            editItemViewModel.showAlert = true
                        }
                        
                    }
                    .disabled(editItemViewModel.isLoading)
                    .padding()
                }
            }
            .alert(isPresented: $editItemViewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(editItemViewModel.alertMessage)
                )
            }
        }
    }
    
    
    
    
    @ViewBuilder
    func displayAlertMessage() -> some View {
        if !editItemViewModel.alertMessage.isEmpty {
            Text("✅ \(editItemViewModel.alertMessage)")
                .animation(.easeInOut(duration: 2), value: editItemViewModel.itemEdited)
                .foregroundColor(Color.green)
            
        }
    }
    
}

#Preview {
    TodoListItemEditView(
        
        item:
                .init(
                    id: "123",
                    title: "Buy Water",
                    description: "",
                    dueDate: Date().timeIntervalSince1970,
                    category: "Work",
                    createdDate: Date().timeIntervalSince1970,
                    completedDate: 0,
                    isDone: false,
                    isStarred: false
                )
    )
}

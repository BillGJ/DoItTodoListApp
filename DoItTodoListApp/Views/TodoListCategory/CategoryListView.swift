//
//  CategoryListView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/8/25.
//

import FirebaseFirestore
import SwiftUI


struct CategoryListView: View {
    
    @StateObject var categoryListViewModel: CategoryListViewViewModel
    @FirestoreQuery var categoryItems: [TodoListCategory]
    @FirestoreQuery var items: [TodoListItem]
    @State var showingAlert = false
    
    @State var searchedText: String = ""
    @State var filteredCategoryItems: [TodoListCategory] = []
    
    // Filtered results based on the search query
    private var filteredCategoryItemsResult: [TodoListCategory] {
        categoryItems.filter { category in
            searchedText.isEmpty || category.name.localizedCaseInsensitiveContains(searchedText)
        }
    }
    
    
       
    init (userId: String) {
        //        self.userId = userId
        // users/<id>/todos/<entries>
        self._categoryItems = FirestoreQuery(collectionPath: "users/\(userId)/todoCategories",
                                             predicates: [.order(by: "createdDate")]
        )
        
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos",
                                     predicates: [.order(by: "dueDate")]
        )
        
        self._categoryListViewModel = StateObject(wrappedValue: CategoryListViewViewModel(userId: userId))
        
    }
    
    
    var body: some View {
        NavigationView {
            VStack {

                List(filteredCategoryItemsResult) { categoryItem in
                    let todoItemCount: Int = countItemsByCategory(todoItems: items, categoryName: categoryItem.name)
                    
                    if AppConstants.PrefilledCategoryNames.contains(categoryItem.name) {
                        categoryListItemViewNotDeleteable(categoryItem: categoryItem, todoItemCount: todoItemCount)
                    } else {
                    
//                    if categoryItem.name != "All" && categoryItem.name != "No Category" {
                        if todoItemCount > 0 {
                            
                            NavigationLink(
                                destination: CategoryListItemEditView(
                                    category: categoryItem
                                ),
                                label: {
                                    categoryListItemViewDeletableWithAlert(categoryItem: categoryItem, todoItemCount: todoItemCount)
                                }
                            )
//                            categoryListItemViewDeletableWithAlert(categoryItem: categoryItem, todoItemCount: todoItemCount)
                            
                        } else {
                            NavigationLink(
                                destination: CategoryListItemEditView(
                                    category: categoryItem
                                ),
                                label: {
                                    categoryListItemViewDeletableWithoutAlert(categoryItem: categoryItem, todoItemCount: todoItemCount)
                                }
                            )
//                            categoryListItemViewDeletableWithoutAlert(categoryItem: categoryItem, todoItemCount: todoItemCount)
                            
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .searchable(text: $searchedText)
                
                .onChange(of: searchedText, {
                    filterCategories(searchedText: searchedText)
                })
            }
            .navigationTitle("Manage Categories")
            .toolbar {
                Button {
                    // Action
                    categoryListViewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color.green)
                }
            }
            .sheet(isPresented: $categoryListViewModel.showingNewItemView) {
                NewCategoryView(newItemPresented: $categoryListViewModel.showingNewItemView)
                    .presentationDetents([.fraction(0.40)])
                
            }
        }
    }
    
    @ViewBuilder
    func categoryListItemViewDeletableWithAlert(categoryItem: TodoListCategory, todoItemCount: Int) -> some View {
        CategoryListItemView(categoryItem: categoryItem, todoItemCount: todoItemCount)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Warning!"),
                    message: Text("If you delete this category, all items in that category will be deleted. Tap 'Yes' to proceed."),
                    primaryButton: Alert.Button.destructive(Text("Yes"), action: {
                        categoryListViewModel.deleteTodosByCategoryName(name: categoryItem.name)
                        categoryListViewModel.delete(id: categoryItem.id)
                    }),
                    secondaryButton: Alert.Button.default(Text("No"), action: {
                    })
                )
            }
            .swipeActions {
                Button("Delete") {
                    withAnimation { showingAlert.toggle() }
                }
                .tint(.red)
            }
    }
    
    @ViewBuilder
    func categoryListItemViewDeletableWithoutAlert(categoryItem: TodoListCategory, todoItemCount: Int) -> some View {
        CategoryListItemView(categoryItem: categoryItem, todoItemCount: todoItemCount)
            .swipeActions {
                Button("Delete") {
                    categoryListViewModel.delete(id: categoryItem.id)
                }
                .tint(.red)
            }
    }
    
    
    @ViewBuilder
    func categoryListItemViewNotDeleteable(categoryItem: TodoListCategory, todoItemCount: Int) -> some View {
        CategoryListItemView(categoryItem: categoryItem, todoItemCount: todoItemCount)
    }
    
    
    func countItemsByCategory(todoItems: [TodoListItem], categoryName: String) -> Int {
        
        var count: Int = 0
        
        items.forEach { item in
            if item.category.lowercased() == categoryName.lowercased() {
                count += 1
            }
        }
        
        return count
    }
    
    
    func filterCategories(searchedText: String) {
        
        if searchedText.isEmpty {
            self.filteredCategoryItems = self.categoryItems
        } else {
            self.filteredCategoryItems = self.categoryItems.filter { item in
                return item.name.localizedCaseInsensitiveContains(searchedText)
            }
        }
        
    }
    
}

#Preview {
    CategoryListView(userId: "")
}

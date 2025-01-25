//
//  StarredTodoListView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/19/25.
//

import FirebaseFirestore
import SwiftUI

struct StarredTodoListView: View {
    
    @StateObject var todoListViewModel: TodoListViewViewModel
    @FirestoreQuery var items: [TodoListItem]
    @FirestoreQuery var categoryItems: [TodoListCategory]
    
    @State private var selectedCategory: String = "All"
    
    // Search todos variables
    @State var searchedText = ""
    @State var filteredStarredItems: [TodoListItem] = []
  
    
    var starredItems: [TodoListItem] {

        if selectedCategory == "All" {
            return items
        } else  {
            return items.filter { $0.category == selectedCategory }
        }
        
    }
    
    // Filtered results based on the search query
    private var filteredStarredItemsResult: [TodoListItem] {
        starredItems.filter { todo in
            searchedText.isEmpty || todo.title.localizedCaseInsensitiveContains(searchedText)
        }
    }
    
    
    init (userId: String) {
        //        self.userId = userId
        // users/<id>/todos/<entries>
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos",
                                     predicates: [
                                        .whereField("isStarred", isEqualTo: true),
                                        .order(by: "dueDate", descending: true)
                                     ]
        )
        
        self._categoryItems = FirestoreQuery(collectionPath: "users/\(userId)/todoCategories", predicates: [.order(by: "createdDate")]
        )
        
        self._todoListViewModel = StateObject(wrappedValue: TodoListViewViewModel(userId: userId))
    
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(categoryItems) { category in
                            CategoryButton(
                                category: category.name,
                                isSelected: selectedCategory == category.name
                            ) {
                                selectedCategory = category.name
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                
                List {
                    starredItemsList()
                    
                    if starredItems.isEmpty {
                        
                        Text("No Starred Todos Saved Yet")
                        
                        Spacer()
                        
                        Button(action: {
                            // Handling logout action here
                            todoListViewModel.showingNewItemView = true
                            
                        }) {
                            
                            Text("Add todo")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(15)
                        }
                    }
                    
                }
                .listStyle(PlainListStyle())
                .searchable(text: $searchedText, placement: .navigationBarDrawer(displayMode: .always))
                .refreshable {
                    await refresh()
                }
                .onChange(of: searchedText, {
                    filterTodos(searchedText: searchedText)
                })
                
            }
            .navigationTitle("Starred Todos")
            .toolbar {
                Button {
                    // Action
                    todoListViewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color.green)
                }
            }
            .sheet(isPresented: $todoListViewModel.showingNewItemView) {
                NewItemView(newItemPresented: $todoListViewModel.showingNewItemView)
                    .presentationDetents([.fraction(0.80)])
            }
        }
    }
    
    @ViewBuilder
    func starredItemsList() -> some View {
        if !starredItems.isEmpty {
            
            ForEach(filteredStarredItemsResult) { item in
                
                NavigationLink(
                    destination: TodoListItemEditView(
                        item: item
                    ),
                    label: {
                        TodoListItemView(item: item)
                            .swipeActions {
                                Button("Delete") {
                                    todoListViewModel.delete(id: item.id)
                                }
                                .tint(.red)
                            }
                    }
                )
                
            }
        }
    }
    
    
    func filterTodos(searchedText: String){
        
        if searchedText.isEmpty {
            self.filteredStarredItems = self.starredItems
        } else {
            self.filteredStarredItems = self.starredItems.filter { item in
                return item.title.localizedCaseInsensitiveContains(searchedText) || item.category.localizedCaseInsensitiveContains(searchedText)
            }
        }
    }
    
    
    func refresh() async {
        todoListViewModel.objectWillChange.send()
    }
    
    
}

#Preview {
    StarredTodoListView(
        userId: "BothYj1hIeTE4xcBlevPwJtGhQy1"
    )
}

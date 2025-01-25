//
//  PastTodoListView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/22/25.
//

import FirebaseFirestore
import SwiftUI

struct PastTodoListView: View {
    
    @StateObject var todoListViewModel: TodoListViewViewModel
    @FirestoreQuery var items: [TodoListItem]
    @FirestoreQuery var categoryItems: [TodoListCategory]
    
    @State private var selectedCategory: String = "All"
    
    // Search todos variables
    @State var searchedText = ""
    @State var filteredPastItems: [TodoListItem] = []
    
    var pastItems: [TodoListItem] {

        let currentDate = Date() // Current time as TimeInterval
        
        if selectedCategory == "All" {
            return items.filter {
                Date(timeIntervalSince1970: $0.dueDate) < currentDate
            }
        } else  {
            return items.filter{
                $0.category == selectedCategory &&
                Date(timeIntervalSince1970: $0.dueDate) < currentDate
            }
        }
    }
    
    
    
    // Filtered results based on the search query
    private var filteredPastItemsResult: [TodoListItem] {
        pastItems.filter { todo in
            searchedText.isEmpty || todo.title.localizedCaseInsensitiveContains(searchedText)
        }
    }
    
    
    init (userId: String) {
        //        self.userId = userId
        // users/<id>/todos/<entries>
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos",
                                     predicates: [
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
                    pastItemsList()
                    
                    if pastItems.isEmpty {
                        
                        Text("No Past Todos Saved Yet")
                        
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
            .navigationTitle("Past Todos")
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
    func pastItemsList() -> some View {
        if !pastItems.isEmpty {
            
            ForEach(filteredPastItemsResult) { item in
                
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
            self.filteredPastItems = self.pastItems
        } else {
            self.filteredPastItems = self.pastItems.filter { item in
                return item.title.localizedCaseInsensitiveContains(searchedText) || item.category.localizedCaseInsensitiveContains(searchedText)
            }
        }
    }
    
    
    func refresh() async {
        todoListViewModel.objectWillChange.send()
    }
    
}

#Preview {
    PastTodoListView(
        userId: "BothYj1hIeTE4xcBlevPwJtGhQy1"
    )
}

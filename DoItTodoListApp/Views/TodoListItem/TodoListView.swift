//
//  TodoListView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import FirebaseFirestore
import SwiftUI

struct TodoListView: View {
    
    @StateObject var todoListViewModel: TodoListViewViewModel
    @FirestoreQuery var items: [TodoListItem]
    @FirestoreQuery var categoryItems: [TodoListCategory]
    
    @State private var selectedCategory: String = "All"
    
    // Search todos variables
    @State var searchedText = ""
    @State var filteredTodayItems: [TodoListItem] = []
    @State var filteredUpcomingItems: [TodoListItem] = []
    
    @AppStorage("isTodaySectionVisible")
    private var isTodaySectionVisible = true
    @AppStorage("isUpcomingSectionVisible")
    private var isUpcomingSectionVisible = true
    
    
    var todayItems: [TodoListItem] {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)!
        
        return items.filter { item in
            if selectedCategory != "All" {
                item.category == selectedCategory &&
                Date(timeIntervalSince1970: item.dueDate) >= todayStart &&
                Date(timeIntervalSince1970: item.dueDate) < todayEnd
            } else {
                Date(timeIntervalSince1970: item.dueDate) >= todayStart &&
                Date(timeIntervalSince1970: item.dueDate) < todayEnd
            }
        }
    }
    
    var upcomingItems: [TodoListItem] {
        let calendar = Calendar.current
        let todayEnd = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date()))!
        
        return items.filter { item in
            if selectedCategory != "All" {
                item.category == selectedCategory &&
                Date(timeIntervalSince1970: item.dueDate) >= todayEnd
            } else {
                Date(timeIntervalSince1970: item.dueDate) >= todayEnd
            }
            
        }
    }
    
    
    // Filtered results based on the search query
    private var filteredTodayItemsResult: [TodoListItem] {
        todayItems.filter { todo in
            searchedText.isEmpty || todo.title.localizedCaseInsensitiveContains(searchedText)
        }
    }
    
    private var filteredUpcomingItemsResult: [TodoListItem] {
        upcomingItems.filter { todo in
            searchedText.isEmpty || todo.title.localizedCaseInsensitiveContains(searchedText)
        }
    }
    
    
    init (userId: String) {
        //        self.userId = userId
        // users/<id>/todos/<entries>
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos",
                                     predicates: [.order(by: "dueDate")]
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
                    todayItemsList()
                    
                    if todayItems.isEmpty {
                        
                        Text("No Todos for Today")
                    }
                    
                    upcomingItemsList()
                    
                    if upcomingItems.isEmpty {
                        
                        Text("No Upcoming Todos")
                    }
                    
                    if todayItems.isEmpty && upcomingItems.isEmpty {
                        
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
                //                .listStyle(InsetGroupedListStyle())
                .searchable(text: $searchedText, placement: .navigationBarDrawer(displayMode: .always))
                .refreshable {
                    await refresh()
                }
                .onChange(of: searchedText, {
                    filterTodos(searchedText: searchedText)
                })
                
            }
            .navigationTitle("Todos")
            .foregroundColor(Color.red)
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
    func todayItemsList() -> some View {
        Section(header: SectionHeaderView("Today's Todos", isVisible: $isTodaySectionVisible, count: todayItems.count)) {
            if !todayItems.isEmpty {
                if isTodaySectionVisible {
                    ForEach(filteredTodayItemsResult) { item in
                        
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
                        
                        //                    TodoListItemView(item: item)
                        //                        .onTapGesture {
                        //                            todoListViewModel.showingItemEditView = true
                        //                            print(item.title)
                        //                        }
                        //                        .swipeActions {
                        //                            Button("Delete") {
                        //                                todoListViewModel.delete(id: item.id)
                        //                            }
                        //                            .tint(.red)
                        //                        }
                        //                        .sheet(isPresented: $todoListViewModel.showingItemEditView) {
                        //                            TodoListItemEditView(
                        //                                item: item,
                        //                                itemEditIsPresented: $todoListViewModel.showingItemEditView
                        //                            )
                        //                            .presentationDetents([.fraction(0.80)])
                        //                        }
                    }
                    
                }
            }
        }
        .listRowBackground(Color.gray.opacity(0.1)) // Background color for rows
        
        
    }
    
    
    @ViewBuilder
    func upcomingItemsList() -> some View {
        Section(header: SectionHeaderView("Upcoming Todos", isVisible: $isUpcomingSectionVisible, count: upcomingItems.count)) {
            if !upcomingItems.isEmpty {
                if isUpcomingSectionVisible {
                    ForEach(filteredUpcomingItemsResult) { item in
                        
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
        }
        .listRowBackground(Color.gray.opacity(0.1)) // Background color for rows
        
        
    }
    
    
    func filterTodos(searchedText: String){
        
        if searchedText.isEmpty {
            self.filteredTodayItems = self.todayItems
            self.filteredUpcomingItems = self.upcomingItems
        } else {
            self.filteredTodayItems = self.todayItems.filter { item in
                return item.title.localizedCaseInsensitiveContains(searchedText) || item.category.localizedCaseInsensitiveContains(searchedText)
            }
            
            self.filteredUpcomingItems = self.upcomingItems.filter { item in
                return item.title.localizedCaseInsensitiveContains(searchedText) || item.category.localizedCaseInsensitiveContains(searchedText)
            }
        }
    }
    
    
    func refresh() async {
        todoListViewModel.objectWillChange.send()
    }
    
    
    // Styled Section Header
    private func StyledHeader(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.headline)
            .bold()
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
            )
            .padding(.bottom, 4)
    }
    
    
    
    private func SectionHeaderView(_ title: String, isVisible: Binding<Bool>, count: Int) -> some View {
        Button(action: {
            withAnimation {
                isVisible.wrappedValue.toggle()
            }
        }) {
            HStack {
                Image(systemName: "calendar")
                               .foregroundColor(.white)
                Text("\(title.uppercased()) (\(count))")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: isVisible.wrappedValue ? "chevron.up" : "chevron.down")
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
    
}




#Preview {
    TodoListView(userId: "")
}

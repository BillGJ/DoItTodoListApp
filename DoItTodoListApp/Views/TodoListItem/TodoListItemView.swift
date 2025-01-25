//
//  TodoListItemView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import SwiftUI

struct TodoListItemView: View {
    @StateObject var todoListItemViewModel = TodoListItemViewViewModel()
    let item: TodoListItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(todoListItemViewModel.truncatedText(item.title))
                    .lineLimit(1) // Ensure the text stays on one line
                    .truncationMode(.tail) // Truncate text with "..."
                    .foregroundColor(.primary) // Adjust color for better readability
                    .font(.body)
                    .strikethrough(item.isDone)
                
                Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(todoListItemViewModel.isOverdue(item: item) ? Color(.red) : Color(.secondaryLabel))

                statusTag
                    .animation(.easeInOut, value: item.status)
                
                
                //                if todoListItemViewModel.isOverdue(item: item) {
                //                    overdueTag
                //                } else if !todoListItemViewModel.isOverdue(item: item) && !item.isDone {
                //                    pendingTag
                //                } else if item.isDone {
                //                    completedTag
                //                }
            }
            
            Spacer()
            
            Image(systemName: item.isStarred ? "star.fill" : "star")
                .foregroundColor(item.isStarred ? Color.yellow : Color.yellow)
                .onTapGesture {
                    todoListItemViewModel.toggleIsStarred(item: item)
                }
            
            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isDone ? Color.green : Color.red)
                .onTapGesture {
                    todoListItemViewModel.toggleIsDone(item: item)
                }
            
        }
        
        
    }
    
    
    
    // Tag View based on status
    private var statusTag: some View {
        switch item.status {
        case .overdue:
            return Label("Overdue", systemImage: "exclamationmark.triangle.fill")
                .tagStyle(backgroundColor: .red)
        case .pending:
            return Label("Pending", systemImage: "clock.fill")
                .tagStyle(backgroundColor: .orange)
        case .isDone:
            return Label("Completed", systemImage: "checkmark.circle.fill")
                .tagStyle(backgroundColor: .green)
        }
    }
    
    
}

#Preview {
    TodoListItemView(
        
        item: .init(
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

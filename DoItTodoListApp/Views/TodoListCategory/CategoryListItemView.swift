//
//  CategoryListItemView.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/8/25.
//

import SwiftUI

struct CategoryListItemView: View {
    //    @StateObject var categoryListItemViewModel = CategoryListItemViewViewModel()
    let categoryItem: TodoListCategory
    let todoItemCount: Int
    
    var body: some View {
        HStack {
            Text(categoryItem.name)
                .font(.body)
            
            Spacer()
            
            Text("\(todoItemCount)")
                .font(.footnote)
                .foregroundColor(Color(.secondaryLabel))
        }
    }
}

#Preview {
    CategoryListItemView(
        categoryItem: .init(
            id: "123",
            name: "Work",
//            color: "#FFFFFF",
            createdDate: Date().timeIntervalSince1970
        ),
        todoItemCount: 1
    )
}

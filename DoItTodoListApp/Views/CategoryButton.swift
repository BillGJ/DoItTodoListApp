//
//  CategoryButton.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 1/8/25.
//

import SwiftUI

// Custom Button for Category
struct CategoryButton: View {
    let category: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category)
                .fontWeight(isSelected ? .bold : .regular)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                .cornerRadius(20)
                .foregroundColor(isSelected ? .red : .gray)
        }
    }
}

#Preview {
    CategoryButton(category: "", isSelected: false){
        
    }
}

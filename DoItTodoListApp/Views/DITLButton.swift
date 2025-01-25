//
//  DITLButton.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import SwiftUI

struct DITLButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        
        Button {
            // Action
            action()
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                
                Text(title)
                    .foregroundStyle(Color.white)
                    .bold()
            }
        }
    }
}

#Preview {
    DITLButton(title: "Title", background: .pink){
        // Action
    }
}

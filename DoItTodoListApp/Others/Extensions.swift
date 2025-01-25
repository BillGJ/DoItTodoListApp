//
//  Extensions.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import Foundation
import SwiftUI

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}


extension Text {
    func tagStyle(backgroundColor: Color) -> some View {
        self
            .font(.caption)
            .bold()
            .padding(4)
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}


extension Label {
    func tagStyle(backgroundColor: Color) -> some View {
        self
            .font(.caption)
            .bold()
            .padding(4)
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(10)
    }
}

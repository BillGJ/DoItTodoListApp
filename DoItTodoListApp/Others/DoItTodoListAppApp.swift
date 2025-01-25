//
//  DoItTodoListAppApp.swift
//  DoItTodoListApp
//
//  Created by Ebillson Grand Jean on 12/31/24.
//

import FirebaseCore
import SwiftUI

@main
struct DoItTodoListAppApp: App {
    
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

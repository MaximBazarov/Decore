//
//  TodoListApp.swift
//  TodoList
//
//  Created by Maxim Bazarov on 23.11.21.
//

import SwiftUI
import Decore

@main
struct TodoListApp: App {
    @Bind(AllTodos.self) var todos
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Text("Todos count \(todos.count)")
                NavigationView {
                    NavigationLink("Todo List") {
                        ContentView()
                    }
                }
            }
        }
    }
}

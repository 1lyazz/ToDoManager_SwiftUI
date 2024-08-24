//
//  ToDoManagerSwiftUIApp.swift
//  ToDoManagerSwiftUI
//
//  Created by Ilya Zablotski on 24.08.24.
//

import SwiftUI

@main
struct ToDoManagerSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

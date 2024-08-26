//  ToDoManagerSwiftUIApp.swift
//  ToDoManagerSwiftUI
//  Created by Ilya Zablotski

import SwiftUI

@main
struct ToDoManagerSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext
            let dateHolder = DateHolder(context)

            TaskListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(dateHolder)
        }
    }
}

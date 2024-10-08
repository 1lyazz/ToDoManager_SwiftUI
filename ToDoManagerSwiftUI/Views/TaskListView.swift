//  ContentView.swift
//  ToDoManagerSwiftUI
//  Created by Ilya Zablotski

import CoreData
import SwiftUI

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder

    @State var selectedFilter = TaskFilter.NonCompleted

    var body: some View {
        NavigationView {
            VStack {
                DateScroller()
                    .padding()
                    .environmentObject(dateHolder)
                ZStack {
                    List {
                        ForEach(filteredTaskItems()) { taskItem in
                            NavigationLink(destination: TaskEditView(passedTaskItem: taskItem, initialDate: taskItem.dueDate!)
                                .environmentObject(dateHolder))
                            {
                                TaskCell(passedTaskItem: taskItem)
                                    .environmentObject(dateHolder)
                            }
                        }

                        .onDelete(perform: deleteItems)
                    }

                    .toolbar {
                        ToolbarItemGroup(placement: .topBarLeading) {
                            Spacer()
                            Picker("", selection: $selectedFilter.animation()) {
                                ForEach(TaskFilter.allFilters, id: \.self) { filter in
                                    Text(filter.rawValue)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .tint(.yellow)
                            Spacer()
                        }
                    }

                    FloatingButton()
                        .environmentObject(dateHolder)
                }
            }

            .navigationTitle("To Do List")
        }
    }

    private func filteredTaskItems() -> [TaskItem] {
        if selectedFilter == TaskFilter.Completed {
            return dateHolder.taskItems.filter { $0.isCompleted() }
        }

        if selectedFilter == TaskFilter.NonCompleted {
            return dateHolder.taskItems.filter { !$0.isCompleted() }
        }

        if selectedFilter == TaskFilter.OverDue {
            return dateHolder.taskItems.filter { $0.isOverdue() }
        }

        return dateHolder.taskItems
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredTaskItems()[$0] }.forEach(viewContext.delete)

            dateHolder.saveContext(viewContext)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

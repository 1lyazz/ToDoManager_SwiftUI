//  DateHolder.swift
//  ToDoManagerSwiftUI
//  Created by Ilya Zablotski

import CoreData
import SwiftUI

class DateHolder: ObservableObject {
    
    @Published var date = Date()
    @Published var taskItems: [TaskItem] = []
    
    let calendar: Calendar = .current
    
    func moveDate(_ days: Int, _ context: NSManagedObjectContext) {
        guard let newDate = calendar.date(byAdding: .day, value: days, to: date) else { return }
        date = newDate
        refreshTaskItems(context)
    }
        
    init(_ context: NSManagedObjectContext) {
        refreshTaskItems(context)
    }
    
    func refreshTaskItems(_ context: NSManagedObjectContext) {
        taskItems = fetchTaskItems(context)
    }
    
    func fetchTaskItems(_ context: NSManagedObjectContext) -> [TaskItem] {
        do {
            return try context.fetch(dailyTasksFetch())
        } catch {
            print("Unresolved error \(error)")
            return []
        }
    }
    
    func dailyTasksFetch() -> NSFetchRequest<TaskItem> {
        let request = TaskItem.fetchRequest()
        request.sortDescriptors = sortOrder()
        request.predicate = predicate()
        return request
    }
    
    private func sortOrder() -> [NSSortDescriptor] {
        let completedDateSort = NSSortDescriptor(keyPath: \TaskItem.completedDate, ascending: true)
        let timeSort = NSSortDescriptor(keyPath: \TaskItem.scheduleTime, ascending: true)
        let dueDateSort = NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)
        
        return [completedDateSort, timeSort, dueDateSort]
    }
    
    private func predicate() -> NSPredicate {
        let start = calendar.startOfDay(for: date)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return NSPredicate(value: false) }
        return NSPredicate(format: "dueDate >= %@ AND dueDate < %@", start as NSDate, end as NSDate)
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshTaskItems(context)
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

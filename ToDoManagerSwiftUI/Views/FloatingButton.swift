//  FloatingButton.swift
//  ToDoManagerSwiftUI
//  Created by Ilya Zablotski

import SwiftUI

struct FloatingButton: View {
    @EnvironmentObject var dateHolder: DateHolder

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: TaskEditView(passedTaskItem: nil, initialDate: dateHolder.date, isEditMode: false)
                    .environmentObject(dateHolder))
                {
                    Text("+ New Task")
                        .font(.headline)
                }
                .padding(15)
                .foregroundColor(.black)
                .background(Color.yellow)
                .cornerRadius(30)
                .padding(30)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
            }
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton()
    }
}

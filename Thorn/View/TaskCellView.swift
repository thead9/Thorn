//
//  TaskCellView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/7/24.
//

import SwiftData
import SwiftUI

/// View for a task cell
struct TaskCellView: View {
  @Environment(\.modelContext) private var modelContext
  @State private var taskName: String
  @FocusState private var isTaskNameFocused: Bool
  
  /// Task this cell is associated with
  let task: Task
  
  /// Creates a TaskCellView
  /// - Parameter task: Task for the view
  init(task: Task) {
    _taskName = State(initialValue: task.name)
    self.task = task
    self.isTaskNameFocused = true
  }
  
  var body: some View {
    HStack {
      Label("Is Complete", systemImage: task.isCompleted ? "checkmark.circle.fill" : "circle")
        .foregroundStyle(Color.accentColor)
        .labelStyle(.iconOnly)
        .imageScale(.large)
        .onTapGesture {
          withAnimation {
            task.isCompleted.toggle()
          }
        }
      
      TextField("Task Name", text: $taskName)
        .focused($isTaskNameFocused)
        .submitLabel(.done)
        .onSubmit {
          changeName()
        }
        .onChange(of: isTaskNameFocused) {
          if !isTaskNameFocused {
            changeName()
          }
        }
    }
  }
  
  private func changeName() {
    if !taskName.isEmpty {
      task.name = taskName
    } else {
      modelContext.delete(task)
    }
  }
}

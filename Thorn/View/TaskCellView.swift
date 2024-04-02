//
//  TaskCellView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/7/24.
//

import SwiftData
import SwiftUI

/// View for a task cell in a list
struct TaskCellView: View {
  @Environment(\.editMode) private var editMode
  @State private var completionBounceValue: Int = 0
  @State private var editName: String
  
  /// Task this view is associated with
  let task: Task
  
  private var isEditing: Bool {
     editMode?.wrappedValue.isEditing == true
  }
  
  init(task: Task) {
    self.task = task
    _editName = State(initialValue: task.name)
  }
    
  var body: some View {
    HStack(spacing: 15) {
      if isEditing {
        TextField("Task Name", text: $editName)
      }
      else {
        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
          .renderingMode(.original)
          .foregroundColor(Color.accentColor)
          .imageScale(.large)
          .symbolEffect(
            .bounce,
            options: .speed(1.5),
            value: completionBounceValue
          )
        
        Text(task.name)
      }
      
      Spacer()
    }
    .contentShape(Rectangle())
    .onTapGesture {
      if !isEditing {
        withAnimation {
          task.isCompleted.toggle()
          if task.isCompleted {
            completionBounceValue += 1
          }
        }
      }
    }
    .onChange(of: isEditing, initial: false) { oldIsEditing, newIsEditing in
      if oldIsEditing && !newIsEditing {
        task.name = editName
      }
    }
  }
}

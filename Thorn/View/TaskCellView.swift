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
  @State private var completionBounceValue: Int = 0
  
  /// Task this view is associated with
  let task: Task
    
  var body: some View {
    HStack(spacing: 15) {
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
      
      Spacer()
    }
    .contentShape(Rectangle())
    .onTapGesture {
      withAnimation {
        task.isCompleted.toggle()
        if task.isCompleted {
          completionBounceValue += 1
        }
      }
    }
  }
}

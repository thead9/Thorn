//
//  TaskCellView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/7/24.
//

import SwiftData
import SwiftUI

struct TaskCellView: View {
  let task: Task
  
  @State var bounceValue: Int = 0
    
  var body: some View {
    HStack(spacing: 15) {
      Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
        .renderingMode(.original)
        .foregroundColor(Color.accentColor)
        .imageScale(.large)
        .symbolEffect(
          .bounce,
          options: .speed(1.5),
          value: bounceValue
        )
      
      Text(task.name)
      
      Spacer()
    }
    .contentShape(Rectangle())
    .onTapGesture {
      withAnimation {
        task.isCompleted.toggle()
        if task.isCompleted {
          bounceValue += 1
        }
      }
    }
  }
}

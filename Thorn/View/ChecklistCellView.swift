//
//  ChecklistCellView.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import SwiftData
import SwiftUI

/// View for a checklist cell in a list
struct ChecklistCellView: View {
  @Environment(\.modelContext) private var modelContext
  
  private let taskFetchDescriptor: FetchDescriptor<Task>
  private var taskCount: Int {
    get {
      return (try? modelContext.fetchCount(taskFetchDescriptor)) ?? 0
    }
  }
  
  private let completedTaskFetchDescriptor: FetchDescriptor<Task>
  private var completedTaskCount: Int {
    get {
      return (try? modelContext.fetchCount(completedTaskFetchDescriptor)) ?? 0
    }
  }
  
  /// Checklist this view is associated with
  var checklist: Checklist
  
  init(checklist: Checklist) {
    self.checklist = checklist
    
    let id = checklist.id
    
    let taskPredicate = #Predicate<Task> { task in
      task.checklist?.id == id
    }
    taskFetchDescriptor = FetchDescriptor<Task>(predicate: taskPredicate)
    
    let completedTaskPredicate = #Predicate<Task> { task in
      task.checklist?.id == id && task.isCompleted
    }
    completedTaskFetchDescriptor = FetchDescriptor<Task>(predicate: completedTaskPredicate)
  }
    
  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      HStack {
        Text(checklist.name)
          .font(.title2)
          .fontWeight(.bold)
        
        Spacer()
        
        Text("Level")
          .font(.callout)
        
        Text("1")
          .foregroundStyle(Color.accentColor)
          .padding(.vertical, 5)
          .padding(.horizontal, 10)
          .background(Color.accentColor.opacity(0.1))
          .clipShape(RoundedRectangle(cornerRadius: 5))
      }
      
      Divider()
      
      VStack(spacing: 3) {
        HStack(alignment: .bottom) {
          Text("Task Status")
          
          Spacer()
          
          Text("\(completedTaskCount)/\(taskCount)")
            .foregroundStyle(Color.accentColor)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color.accentColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        
        HStack {
          Spacer()
          Text("Progress Bar Here")
          Spacer()
        }
        .padding(5)
        .background(Color.accentColor)
        .foregroundStyle(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 5))
      }
      .font(.caption)
      
      VStack(spacing: 3) {
        HStack(alignment: .bottom) {
          Text("Completions Till Next Level")
          
          Spacer()
          
          Text("\(completedTaskCount)/\(taskCount)")
            .foregroundStyle(Color.accentColor)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color.accentColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        
        HStack {
          Spacer()
          Text("Progress Bar Here")
          Spacer()
        }
        .padding(5)
        .background(Color.accentColor)
        .foregroundStyle(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 5))
      }
      .font(.caption)
    }
    .padding(.vertical, 10)
  }
}

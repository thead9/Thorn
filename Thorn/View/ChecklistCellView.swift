//
//  ChecklistCellView.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import Firnen
import SwiftData
import SwiftUI

/// View for a checklist cell in a list
struct ChecklistCellView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.editMode) private var editMode
  @StateObject private var sheet = SheetContext()
  
  private var taskCount: Int { checklist.taskCount(for: modelContext) }
  private var completedTaskCount: Int { checklist.completedTaskCount(for: modelContext) }
  private var isEditing: Bool { editMode?.wrappedValue.isEditing == true }
  
  /// Checklist this view is associated with
  var checklist: Checklist
    
  var body: some View {
    HStack {
      mainCell
      
      if isEditing {
        editButton
      }
    }
    .padding(.vertical, 10)
    .sheet(sheet)
  }
  
  var editButton: some View {
    Button {
      sheet.present(AppSheet.editChecklist(checklist))
    } label: {
      Label("Edit Checklist", systemImage: "pencil.circle")
        .labelStyle(.iconOnly)
        .foregroundColor(Color.accentColor)
        .imageScale(.large)
    }
  }
  
  var mainCell: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(checklist.name)
        .font(.title2)
        .fontWeight(.bold)
      
      Divider()
      
      HStack {
        Text("Completions")
        
        Text("\(checklist.completionCount)")
          .highlighted()
      }
      
      ProgressView(value: Double(completedTaskCount), total: Double(max(taskCount, 1))) {
        Text("Task Status")
      } currentValueLabel: {
        Text("\(completedTaskCount)/\(taskCount)")
          .foregroundStyle(Color.accentColor)
      }
      .font(.caption)
    }
  }
}

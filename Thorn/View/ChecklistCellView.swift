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
  @Query private var feats: [Feat]
  
  private var isEditing: Bool { editMode?.wrappedValue.isEditing == true }
  
  /// Checklist this view is associated with
  var checklist: Checklist
  
  /// Sheet context for displaying sheets
  var sheet: SheetContext
  
  init(checklist: Checklist, sheet: SheetContext) {
    self.checklist = checklist
    self.sheet = sheet
    
    _feats = Query(filter: checklist.featsPredicate)
  }
    
  var body: some View {
    HStack {
      mainCell
      
      if isEditing {
        editButton
      }
    }
    .padding(.vertical, 10)
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
      
      ProgressView(value: Double(checklist.completedFeatCountExp), total: Double(max(checklist.featCountExp, 1))) {
        Text("Task Status")
      } currentValueLabel: {
        Text("\(checklist.completedFeatCountExp)/\(checklist.featCountExp)")
          .foregroundStyle(Color.accentColor)
      }
      .font(.caption)
    }
  }
}

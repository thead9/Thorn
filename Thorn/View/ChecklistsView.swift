//
//  ChecklistsView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/4/24.
//

import Firnen
import SwiftData
import SwiftUI

/// View for displaying checklists
struct ChecklistsView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.editMode) private var editMode
  @Query private var checklists: [Checklist]
  @StateObject private var sheet = SheetContext()
  
  private var isEditing: Bool { editMode?.wrappedValue.isEditing == true }
  
  var body: some View {
    List {
      ForEach(checklists, id: \.self) { checklist in
        ChecklistNavigationLink(checklist: checklist)
          .separatedCell()
          .contextMenu { contextMenu(for: checklist) }
      }
      .onDelete(perform: deleteItems)
      
      addChecklistButton
        .padding(.vertical)
        .separatedCell()
    }
    .navigationDestination(for: Checklist.self) { ChecklistView(checklist: $0) }
    .toolbar { toolbar }
    .sheet(sheet)
  }
  
  @ToolbarContentBuilder
  private var toolbar: some ToolbarContent {
    ToolbarItemGroup(placement: .topBarTrailing)
    {
      EditButton()
      
      Button {
        sheet.present(AppSheet.addChecklist)
      } label: {
        Label("Create New Checklist", systemImage: "plus")
      }
    }
  }
  
  @ViewBuilder
  private var addChecklistButton: some View {
    Button {
      sheet.present(AppSheet.addChecklist)
    } label: {
      Label("Create New Checklist", systemImage: "plus")
    }
  }
  
  @ViewBuilder
  private func editChecklistButton(for checklist: Checklist) -> some View {
    Button {
      sheet.present(AppSheet.editChecklist(checklist))
    } label: {
      Label("Edit Checklist", systemImage: "pencil")
    }
  }
  
  @ViewBuilder
  private func contextMenu(for checklist: Checklist) -> some View {
    editChecklistButton(for: checklist)
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(checklists[index])
      }
    }
  }
}

/// Oddly needed because isEditing doesn't appear to change when this is in its parent view
private struct ChecklistNavigationLink: View {
  @Environment(\.editMode) private var editMode
  
  private var isEditing: Bool { editMode?.wrappedValue.isEditing == true }
  
  /// Checklist for the navigation link
  let checklist: Checklist
  
  var body: some View {
    if !isEditing {
      NavigationLink(value: checklist) {
        ChecklistCellView(checklist: checklist)
      }
    } else {
      ChecklistCellView(checklist: checklist)
    }
  }
}

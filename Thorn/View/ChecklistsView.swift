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
  @EnvironmentObject private var purchaseManager: PurchaseManager
  @Query private var checklists: [Checklist]
  @Query private var feats: [Feat]
  @StateObject private var sheet = SheetContext()
  
  private var isEditing: Bool { editMode?.wrappedValue.isEditing == true }
  
  var body: some View {
    List {
      ForEach(checklists, id: \.self) { checklist in
        ChecklistNavigationLink(checklist: checklist, sheet: sheet)
          .separatedCell()
          .contextMenu { contextMenu(for: checklist) }
      }
      .onDelete(perform: deleteItems)
      
      Section {
        addChecklistButton
          .foregroundStyle(Color.accentColor)
      }
    }
    .navigationDestination(for: Checklist.self) { ChecklistView(checklist: $0) }
    .toolbar { toolbar }
    .sheet(sheet)
  }
  
  @ToolbarContentBuilder
  private var toolbar: some ToolbarContent {
    ToolbarItemGroup(placement: .topBarLeading) {
      Button {
        sheet.present(AppSheet.settings)
      } label: {
        Label("Settings", systemImage: "gearshape")
      }
    }
    
    ToolbarItemGroup(placement: .topBarTrailing) {
      EditButton()
      
      addChecklistButton
    }
  }
  
  @ViewBuilder
  private var addChecklistButton: some View {
    Button {
      if purchaseManager.hasUnlockedPlus || modelContext.checklistCount() < CheckPlus.freeLists {
        sheet.present(AppSheet.addChecklist)
      } else {
        sheet.present(AppSheet.paywall)
      }
    } label: {
      Label("Create New Checklist", systemImage: "plus")
    }
  }
  
  @ViewBuilder
  private func editChecklistButton(for checklist: Checklist) -> some View {
    Button {
      sheet.present(AppSheet.editChecklist(checklist))
    } label: {
      Label("Edit Checklist", systemImage: "pencil.circle")
    }
  }
  
  @ViewBuilder
  private func contextMenu(for checklist: Checklist) -> some View {
    editChecklistButton(for: checklist)
    Button(role: .destructive) {
      modelContext.delete(checklist: checklist)
    } label: {
      Label("Delete Checklist", systemImage: "trash")
    }
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
  
  /// Sheet context for displaying sheets for this cell
  let sheet: SheetContext
  
  var body: some View {
    if !isEditing {
      NavigationLink(value: checklist) {
        ChecklistCellView(checklist: checklist, sheet: sheet)
      }
    } else {
      ChecklistCellView(checklist: checklist, sheet: sheet)
    }
  }
}

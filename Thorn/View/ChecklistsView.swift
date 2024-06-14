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
    
  var body: some View {
    List {
      ForEach(checklists, id: \.self) { checklist in
        if editMode?.wrappedValue.isEditing == true {
          Button {
            sheet.present(AppSheet.editChecklist(checklist))
          } label: {
            ChecklistCellView(checklist: checklist, sheet: sheet)
          }
          .buttonStyle(.plain)
        }
        else {
          NavigationLink(value: checklist) {
            ChecklistCellView(checklist: checklist, sheet: sheet)
          }
          .contextMenu { contextMenu(for: checklist) }
        }
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

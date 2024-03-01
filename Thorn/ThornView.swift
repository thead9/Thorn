//
//  ThornView.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import SwiftData
import SwiftUI

struct ThornView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var checklists: [Checklist]
  
  var body: some View {
    NavigationSplitView {
      checklistsView
    } detail: {
      Text("Please select a Checklist")
    }
  }
  
  private var checklistsView: some View {
    List {
      ForEach(checklists) { checklist in
        ChecklistCellView(checklist: checklist)
      }
      .onDelete(perform: deleteItems)
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        EditButton()
      }
      ToolbarItem {
        Button(action: addItem) {
          Label("Add Item", systemImage: "plus")
        }
      }
    }
  }
  
  private func addItem() {
    withAnimation {
      _ = Checklist.newItem(named: "Test", for: modelContext)
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

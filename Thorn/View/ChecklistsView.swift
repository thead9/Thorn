//
//  ChecklistsView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/4/24.
//

import SwiftData
import SwiftUI

struct ChecklistsView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var checklists: [Checklist]
  @State private var isNewListSheetPresented = false
  
  var body: some View {
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
        Button {
          isNewListSheetPresented = true
        } label: {
          Label("Add Item", systemImage: "plus")
        }
      }
    }
    .sheet(isPresented: $isNewListSheetPresented) {
      NavigationStack {
        AddChecklistView()
      }
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

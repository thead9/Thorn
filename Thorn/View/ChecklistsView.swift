//
//  ChecklistsView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/4/24.
//

import SwiftData
import SwiftUI

/// View for displaying checklists
struct ChecklistsView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var checklists: [Checklist]
  @State private var isNewListSheetPresented = false
  
  /// Selected checklist
  @Binding var selectedChecklist: Checklist?
  
  var body: some View {
    List(selection: $selectedChecklist) {
      ForEach(checklists, id: \.self) { checklist in
        ChecklistCellView(checklist: checklist)
          .listRowSeparator(.hidden)
          .listRowBackground(
            RoundedRectangle(cornerRadius: 10)
              .background(.clear)
              .foregroundColor(Color(UIColor.secondarySystemGroupedBackground))
              .padding(.vertical, 5)
          )
      }
      .onDelete(perform: deleteItems)
    }
    //.listStyle(.plain)
    .toolbar {
      ToolbarItemGroup(placement: .topBarTrailing)
      {
        EditButton()
        
        Button {
          isNewListSheetPresented = true
        } label: {
          Label("Add Item", systemImage: "plus")
        }
      }
    }
    .sheet(isPresented: $isNewListSheetPresented) {
      NavigationStack {
        ChecklistAddView()
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

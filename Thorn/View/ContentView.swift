//
//  ContentView.swift
//  Thorn
//
//  Created by Thomas Headley on 2/23/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var checklists: [Checklist]
  
  var body: some View {
    NavigationSplitView {
      List {
        ForEach(checklists) { checklist in
          NavigationLink {
            Text("\(checklist.name): \(checklist.dateCreated, format: Date.FormatStyle(date: .numeric, time: .standard))")
          } label: {
            Text("\(checklist.name): \(checklist.dateCreated, format: Date.FormatStyle(date: .numeric, time: .standard))")
          }
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
    } detail: {
      Text("Select an item")
    }
  }
  
  private func addItem() {
    withAnimation {
      _ = Checklist.newItemForContext(name: "Test", context: modelContext)
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

#Preview {
  ContentView()
    .modelContainer(for: Checklist.self, inMemory: true)
}

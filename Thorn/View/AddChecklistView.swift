//
//  AddChecklistView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/4/24.
//

import SwiftUI

/// View for adding a new checklist
struct AddChecklistView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @State private var name = ""
  @FocusState private var focusedField: FocusedField?
  
  var body: some View {
    Form {
      Section {
        TextField("Name", text: $name)
          .focused($focusedField, equals: .name)
      }
    }
    .onAppear {
      focusedField = .name
    }
    .navigationTitle("Add Checklist")
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          Text("Cancel")
        }
      }
      
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          addItem()
          dismiss()
        } label: {
          Text("Save")
        }
      }
    }
  }
  
  private func addItem() {
    withAnimation {
      _ = Checklist.newItem(named: name, for: modelContext)
    }
  }
  
  private enum FocusedField {
    case name
  }
}

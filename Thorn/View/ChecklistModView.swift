//
//  ChecklistModView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/26/24.
//

import Firnen
import SwiftUI

struct ChecklistModView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @State private var name: String
  @FocusState private var focusedField: FocusedField?
  private let modMode: ModMode
  
  private var isNameValid: Bool {
    !name.isEmpty
  }
  
  private var isFormValid: Bool {
    isNameValid
  }
  
  init(_ modMode: ModMode) {
    switch modMode {
    case .add:
      _name = State(initialValue: "")
    case .edit(let checklist):
      _name = State(initialValue: checklist.name)
    }
    
    self.modMode = modMode
  }
  
  var body: some View {
    Form {
      Section {
        TextField("Name", text: $name)
          .focused($focusedField, equals: .name)
          .validatedField(isValid: isNameValid, invalidNotice: .required)
      }
    }
    .onAppear {
      focusedField = .name
    }
    .navigationTitle(modMode.navigationTitle)
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
          modItem()
          dismiss()
        } label: {
          Text("Save")
        }
        .disabled(!isFormValid)
      }
    }
  }
  
  private func modItem() {
    switch modMode {
    case .add:
      withAnimation {
        _ = Checklist.newItem(named: name, for: modelContext)
      }
    case .edit(let checklist):
      checklist.name = name
    }
  }
  
  enum ModMode: Identifiable {
    var id: String {
      switch self {
      case .add:
        "add"
      case .edit(_):
        "edit"
      }
    }
    
    case add
    case edit(_ checklist: Checklist)
    
    var navigationTitle: String {
      get {
        switch self {
        case .add:
          "Add Checklist"
        case .edit(_):
          "Edit Checklist"
        }
      }
    }
  }
  
  private enum FocusedField {
    case name
  }
}

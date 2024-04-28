//
//  ChecklistModView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/26/24.
//

import Firnen
import SwiftUI

/// View for modifying a checklist
struct ChecklistModView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @State private var name: String
  @FocusState private var focusedField: FocusedField?
  
  private let modMode: ModMode
  private var isNameValid: Bool { !name.isEmpty }
  private var isFormValid: Bool { isNameValid }
  
  /// Creates a ChecklistModView with an initial modification mode
  /// - Parameter modMode: Modification mode
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
    .onAppear { focusedField = .name }
    .navigationTitle(modMode.navigationTitle)
    .toolbar { toolbar }
  }
  
  @ToolbarContentBuilder
  private var toolbar: some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button {
        dismiss()
      } label: {
        Text("Cancel")
      }
    }
    
    ToolbarItem(placement: .topBarTrailing) {
      Button {
        modifyItem()
        dismiss()
      } label: {
        Text("Save")
      }
      .disabled(!isFormValid)
    }
  }
  
  private func modifyItem() {
    switch modMode {
    case .add:
      withAnimation {
        _ = Checklist.newItem(named: name, for: modelContext)
      }
    case .edit(let checklist):
      checklist.name = name
    }
  }
  
  private enum FocusedField {
    case name
  }
}

extension ChecklistModView {
  /// Modes for the ChecklistModView can be in
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
    
    /// Gets the navigation title for the mode
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
}

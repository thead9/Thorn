//
//  TaskCellView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/7/24.
//

import SwiftData
import SwiftUI

/// View for a feat cell
struct FeatCellView: View {
  @Environment(\.modelContext) private var modelContext
  @State private var featName: String
  @FocusState private var isFeatNameFocused: Bool
  
  /// Task this cell is associated with
  let feat: Feat
  
  /// Creates a TaskCellView
  /// - Parameter task: Task for the view
  init(feat: Feat) {
    _featName = State(initialValue: feat.name)
    self.feat = feat
    self.isFeatNameFocused = true
  }
  
  var body: some View {
    HStack {
      Label("Is Complete", systemImage: feat.isCompleted ? "checkmark.circle.fill" : "circle")
        .foregroundStyle(Color.accentColor)
        .labelStyle(.iconOnly)
        .imageScale(.large)
        .onTapGesture {
          withAnimation {
            feat.isCompleted.toggle()
          }
        }
      
      TextField("Task Name", text: $featName)
        .focused($isFeatNameFocused)
        .submitLabel(.done)
        .onSubmit {
          changeName()
        }
        .onChange(of: isFeatNameFocused) {
          if !isFeatNameFocused {
            changeName()
          }
        }
    }
  }
  
  private func changeName() {
    if !featName.isEmpty {
      feat.name = featName
    } else {
      modelContext.delete(feat)
    }
  }
}

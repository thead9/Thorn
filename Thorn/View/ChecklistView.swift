//
//  ChecklistView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/5/24.
//

import Firnen
import SwiftData
import SwiftUI

/// View for a specific checklist
struct ChecklistView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.editMode) private var editMode
  @Query private var feats: [Feat]
  @State private var isAddingNewFeat: Bool = false
  @StateObject private var sheet = SheetContext()
  
  /// Checklist associated with this view
  let checklist: Checklist
  
  private var isEditing: Bool { editMode?.wrappedValue.isEditing == true }
  
  /// Creates a ChecklistView
  /// - Parameter checklist: Checklist to create the view for
  init(checklist: Checklist) {
    self.checklist = checklist
    
    _feats = Query(filter: checklist.featsPredicate, sort: [SortDescriptor(\.sortOrder)])
  }
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        header
          .padding(.horizontal)
        
        featsView
      }
      
      if isAddingNewFeat {
        AddNewFeatView(checklist: checklist, isAddingNewFeat: $isAddingNewFeat)
      }
    }
    .navigationTitle(checklist.name)
    .navigationBarTitleDisplayMode(.large)
    .toolbar { toolbar }
    .sheet(sheet)
  }
  
  var header: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Completions")
        
        Text("\(checklist.completionCount)")
          .highlighted()
      }
    }
    .font(.subheadline)
  }
  
  var featsView: some View {
    List {
      Section {
        ForEach(feats, id: \.self) { feat in
          FeatCellView(feat: feat)
            .id(feat.id)
            .contextMenu { contextMenu(for: feat) }
        }
        .onMove(perform: feats.updateSortOrder)
        .onDelete(perform: deleteItems)
      } header: {
        Button {
          withAnimation {
            checklist.reset()
          }
        } label: {
          Text("Reset")
        }
        .textCase(nil)
        .disabled(!feats.contains(where: { $0.isCompleted }))
      }
      
      if !isAddingNewFeat {
        addFeatButton
      }
    }
  }
  
  @ViewBuilder
  private func contextMenu(for feat: Feat) -> some View {
    Button(role: .destructive) {
      modelContext.delete(feat: feat)
    } label: {
      Label("Delete Task", systemImage: "trash")
    }
  }
  
  @ToolbarContentBuilder
  private var toolbar: some ToolbarContent {
    ToolbarItemGroup(placement: .topBarTrailing) {
      EditButton()
      
      Button {
        isAddingNewFeat = true
      } label: {
        Label("Create New Checklist", systemImage: "plus")
      }
    }
  }
  
  @ViewBuilder
  private var addFeatButton: some View {
    Button {
      withAnimation {
        isAddingNewFeat = true
      }
    } label: {
      Label("Create New Task", systemImage: "plus")
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(feats[index])
      }
    }
  }
}

struct AddNewFeatView: View {
  @Environment(\.modelContext) private var modelContext
  @State private var newFeatName = ""
  @FocusState private var isFocused: Bool
  
  let checklist: Checklist
  let isAddingNewFeat: Binding<Bool>
  
  private var isAddableName: Bool { newFeatName.trimmingCharacters(in: .whitespaces).count > 0 }
  
  var body: some View {
    VStack {
      Spacer()
      
      HStack {
        TextField("Task Name", text: $newFeatName)
          .focused($isFocused)
          .padding()
          .background(Color(UIColor.systemBackground))
          .clipShape(Capsule())
          .overlay(
            Capsule()
              .stroke(Color.accentColor, lineWidth: 3)
          )
          .submitLabel(.return)
          .onAppear {
            isFocused = true
          }
          .onSubmit {
            addNewFeat()
            isAddingNewFeat.wrappedValue = false
          }
        
        Button {
          if isAddableName {
            addNewFeat()
          } else {
            stopAddingNewFeat()
          }
        } label: {
          Label("Add Task", systemImage: "arrow.up")
            .labelStyle(.iconOnly)
            .imageScale(.large)
            .rotationEffect(.degrees(isAddableName ? 0 : 180))
            .animation(.easeInOut, value: isAddableName)
        }
        .padding()
        .foregroundColor(.primary)
        .background(Color.accentColor)
        .clipShape(Circle())
      }
      .padding()
    }
    .contentShape(Rectangle())
    .onTapGesture {
      stopAddingNewFeat()
    }
  }
  
  private func addNewFeat() {
    let trimmedName = newFeatName.trimmingCharacters(in: .whitespaces)
    guard trimmedName.count > 0 else {
      return
    }
    
    let feat = Feat.newItem(named: trimmedName, for: modelContext)
    
    withAnimation {
      checklist.add(feat)
      newFeatName = ""
    }
  }
  
  private func stopAddingNewFeat() {
    withAnimation {
      isAddingNewFeat.wrappedValue = false
    }
  }
}

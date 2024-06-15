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
    ScrollViewReader { proxy in
      VStack(alignment: .leading) {
        header
          .padding(.horizontal)
        
        featsList
      }
      .navigationTitle(checklist.name)
      .navigationBarTitleDisplayMode(.large)
      .toolbar { toolbar(proxy) }
      .sheet(sheet)
    }
  }
  
  var header: some View {
    VStack(alignment: .leading) {
      if isEditing {
        Button {
          sheet.present(AppSheet.editChecklist(checklist))
        } label: {
          Label("Edit List Info", systemImage: "pencil")
        }
      }
      
      HStack {
        Text("Completions")
        
        Text("\(checklist.completionCount)")
          .highlighted()
      }
    }
    .font(.subheadline)
  }
  
  var featsList: some View {
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
        HStack {
          Button {
            withAnimation {
              checklist.reset()
            }
          } label: {
            Text("Reset")
          }
          .disabled(!feats.contains(where: { $0.isCompleted }))
        }
        .textCase(nil)
      }
      
      AddNewFeatView(isAddingNewFeat: $isAddingNewFeat, checklist: checklist)
        .id("Add")
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
  private func toolbar(_ proxy: ScrollViewProxy) -> some ToolbarContent {
    ToolbarItemGroup(placement: .topBarTrailing) {
      EditButton()
      
      Button {
        withAnimation {
          isAddingNewFeat = true
          proxy.scrollTo("Add")
        }
      } label: {
        Label("Create New Checklist", systemImage: "plus")
      }
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

fileprivate struct AddNewFeatView: View {
  @Environment(\.modelContext) private var modelContext
  @Binding var isAddingNewFeat: Bool
  @State private var newFeatName: String = ""
  @FocusState private var isFocused: Bool

  let checklist: Checklist
  
  var body: some View {
    if isAddingNewFeat {
      Section {
        TextField("New Task Name", text: $newFeatName)
          .submitLabel(.return)
          .focused($isFocused)
          .onSubmit {
            addNewFeat ()
          }
          .onAppear{
            isFocused = true
          }
      } header: {
        HStack {
          Button {
            reset()
          } label: {
            Text("Cancel")
          }
        }
        .textCase(nil)
      }
    } else {
      Button {
        withAnimation {
          isAddingNewFeat = true
        }
      } label: {
        Label("Create New Task", systemImage: "plus")
      }
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
      reset()
    }
  }
  
  private func reset() {
    withAnimation {
      newFeatName = ""
      isAddingNewFeat = false
    }
  }
}

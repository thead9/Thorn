//
//  ChecklistView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/5/24.
//

import SwiftData
import SwiftUI

/// View for a specific checklist
struct ChecklistView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var tasks: [Task]
  @State private var isAddingNewTask = false
  @State private var newTaskName = ""
  @FocusState private var focusedField: FocusedField?
  
  /// Checklist associated with this view
  let checklist: Checklist
  
  private var isCompleted: Bool {
    get {
      tasks.count > 0 && tasks.allSatisfy({ $0.isCompleted })
    }
  }
  
  private var isAddableName: Bool {
    get {
      newTaskName.trimmingCharacters(in: .whitespaces).count > 0
    }
  }
  
  /// Creates a ChecklistView
  /// - Parameter checklist: Checklist to create the view for
  init(checklist: Checklist) {
    self.checklist = checklist
    
    let id = checklist.id
    let predicate = #Predicate<Task> { task in
      task.checklist?.id == id
    }
    
    _tasks = Query(filter: predicate, sort: [SortDescriptor(\.sortOrder)])
  }
  
  var body: some View {
    ZStack {
      VStack {
        List {
          ForEach(tasks, id: \.self) { task in
            TaskCellView(task: task)
          }
          .onMove(perform: tasks.updateSortOrder)
          .onDelete(perform: deleteItems)
        }
      }
      
      if isAddingNewTask {
        addingNewTaskView
      }
    }
    .navigationTitle("\(checklist.name) \(checklist.completionCount)")
    .toolbar {
      ToolbarItemGroup(placement: .topBarTrailing) {
        Button {
          withAnimation {
            checklist.reset()
          }
        } label: {
          Text("Reset")
        }
        .disabled(!tasks.contains(where: { $0.isCompleted }))
        
        Button {
          withAnimation {
            isAddingNewTask = true
            focusedField = .newTaskTextField
          }
        } label: {
          Label("Add Item", systemImage: "plus")
        }
      }
    }
    .onChange(of: isCompleted, initial: false) {
      if isCompleted {
        checklist.completionCount += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          withAnimation {
            checklist.reset()
          }
        }
      }
    }
  }
  
  private var addingNewTaskView: some View {
    VStack {
      Spacer()
      
      HStack {
        TextField("Task Name", text: $newTaskName)
          .focused($focusedField, equals: .newTaskTextField)
          .padding()
          .background(Color(UIColor.systemBackground))
          .clipShape(Capsule())
          .overlay(
            Capsule()
              .stroke(Color.accentColor, lineWidth: 3)
          )
          .submitLabel(.done)
          .onSubmit {
            addNewTask()
            dismissAddNewTask()
          }
        
        Button {
          addNewTask()
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
      dismissAddNewTask()
    }
    .transition(.move(edge: .bottom))
  }
  
  private func addNewTask() {
    let trimmedName = newTaskName.trimmingCharacters(in: .whitespaces)
    guard trimmedName.count > 0 else {
      return
    }
    
    let task = Task.newItem(named: trimmedName, for: modelContext)
    
    withAnimation {
      checklist.add(task)
      newTaskName = ""
    }
  }
  
  private func dismissAddNewTask() {
    withAnimation {
      focusedField = nil
      isAddingNewTask = false
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(tasks[index])
      }
    }
  }
  
  private enum FocusedField {
    case newTaskTextField
  }
}

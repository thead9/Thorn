//
//  ChecklistView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/5/24.
//

import SwiftData
import SwiftUI

struct ChecklistView: View {
  @Environment(\.modelContext) private var modelContext
  let checklist: Checklist
  @Query private var tasks: [Task]
  @State private var isAddingNewTask = false
  @State private var newTaskName = ""
  @State private var completionCount = 0
  @FocusState private var focusedField: FocusedField?
  
  var isCompleted: Bool {
    get {
      tasks.allSatisfy({ $0.isCompleted })
    }
  }
  
  init(checklist: Checklist) {
    self.checklist = checklist
    
    let id = checklist.id
    let predicate = #Predicate<Task> { task in
      task.checklist?.id == id
    }
    
    _tasks = Query(filter: predicate, sort: [SortDescriptor(\.sortOrder)])
  }
  
  private var isAddableName: Bool {
    get {
      newTaskName.trimmingCharacters(in: .whitespaces).count > 0
    }
  }
  
  var body: some View {
    ZStack {
      VStack {
        List {
          ForEach(tasks, id: \.self) { task in
            TaskCellView(task: task)
          }
          .onMove(perform: tasks.updateSortOrder)
        }
      }
      
      if isAddingNewTask {
        addingNewTaskView
      }
    }
    .navigationTitle("\(checklist.name) \(completionCount)")
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
        completionCount += 1
        
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
  
  private func move( from source: IndexSet, to destination: Int) {
    // Make an array of items from fetched results
    var revisedItems: [Task] = tasks.map{ $0 }
    
    // change the order of the items in the array
    revisedItems.move(fromOffsets: source, toOffset: destination )
    
    // update the userOrder attribute in revisedItems to
    // persist the new order. This is done in reverse order
    // to minimize changes to the indices.
    for reverseIndex in stride( from: revisedItems.count - 1,
                                through: 0,
                                by: -1 )
    {
      revisedItems[reverseIndex].sortOrder = reverseIndex
    }
  }
  
  private enum FocusedField {
    case newTaskTextField
  }
}

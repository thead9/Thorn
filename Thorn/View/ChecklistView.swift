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
  @Environment(\.editMode) private var editMode
  @Query private var tasks: [Task]
  @State private var isAddingNewTask: Bool = false
  
  /// Checklist associated with this view
  let checklist: Checklist
  
  private var taskCount: Int { checklist.taskCount(for: modelContext) }
  private var completedTaskCount: Int { checklist.completedTaskCount(for: modelContext) }
  
  private var isCompleted: Bool {
    tasks.count > 0 && tasks.allSatisfy({ $0.isCompleted })
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
        header
          .padding(.horizontal)
        
        tasksView
      }
      
      if isAddingNewTask {
        AddNewTaskView(checklist: checklist, isAddingNewTask: $isAddingNewTask)
      }
    }
    .navigationTitle(checklist.name)
    .navigationBarTitleDisplayMode(.large)
    .toolbar { toolbar }
    .onChange(of: isCompleted, initial: false) {
      if isCompleted {
        checklist.completionCount += 1
      }
    }
  }
  
  var header: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Completions")
        
        Text("\(checklist.completionCount)")
          .highlighted()
      }
      
      ProgressView(value: Double(completedTaskCount), total: Double(max(taskCount, 1))) {
        Text("Task Status")
      } currentValueLabel: {
        Text("\(completedTaskCount)/\(taskCount)")
          .foregroundStyle(Color.accentColor)
      }
    }
    .font(.subheadline)
  }
  
  var tasksView: some View {
    List {
      Section {
        ForEach(tasks, id: \.self) { task in
          TaskCellView(task: task)
            .id(task.id)
        }
        .onMove(perform: tasks.updateSortOrder)
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
        .disabled(!tasks.contains(where: { $0.isCompleted }))
      }
      
      if !isAddingNewTask {
        addTaskButton        
      }
    }
  }
  
  @ToolbarContentBuilder
  private var toolbar: some ToolbarContent {
    ToolbarItemGroup(placement: .topBarTrailing) {
      EditButton()
    }
  }
  
  @ViewBuilder
  private var addTaskButton: some View {
    Button {
      withAnimation {
        isAddingNewTask = true
      }
    } label: {
      Label("Create New Task", systemImage: "plus")
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(tasks[index])
      }
    }
  }
}

struct AddNewTaskView: View {
  @Environment(\.modelContext) private var modelContext
  @State private var newTaskName = ""
  @FocusState private var isFocused: Bool
  
  let checklist: Checklist
  let isAddingNewTask: Binding<Bool>
  
  private var isAddableName: Bool { newTaskName.trimmingCharacters(in: .whitespaces).count > 0 }
  
  var body: some View {
    VStack {
      Spacer()
      
      HStack {
        TextField("Task Name", text: $newTaskName)
          .focused($isFocused)
          .padding()
          .background(Color(UIColor.systemBackground))
          .clipShape(Capsule())
          .overlay(
            Capsule()
              .stroke(Color.accentColor, lineWidth: 3)
          )
          .submitLabel(.done)
          .onAppear {
            isFocused = true
          }
          .onSubmit {
            addNewTask()
            isAddingNewTask.wrappedValue = false
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
}

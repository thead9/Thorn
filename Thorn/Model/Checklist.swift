//
//  Checklist.swift
//  Thorn
//
//  Created by Thomas Headley on 2/23/24.
//

import Foundation
import SwiftData

@Model
/// A checklist to track completing certain tasks
class Checklist: Identifiable {
  /// Unique Identifier
  let id: UUID
  
  /// Name of the checklist
  var name: String
  
  /// The date the checklist was created
  var dateCreated: Date
  
  /// Number of times this checklist has been completed
  var completionCount: Int

  @Relationship(deleteRule: .cascade, inverse: \Task.checklist)
  /// Tasks associated with this checklist
  var tasks: [Task]
  
  /// Creates a checklist
  /// - Parameter name: Name of the checklist
  init(named name: String) {
    self.id = UUID()
    self.name = name
    self.dateCreated = Date.now
    self.completionCount = 0
    self.tasks = [Task]()
  }
  
  @discardableResult
  /// Creates a checklist and adds it to the specified model context
  /// - Parameters:
  ///   - name: Name of the checklist
  ///   - context: Model context to add the checklist to
  /// - Returns: The checklist itself
  static func newItem(named name: String, for context: ModelContext) -> Checklist {
    let checklist = Checklist(named: name)
    context.insert(checklist)
    
    return checklist
  }
  
  /// Adds a task to this checklist
  /// - Parameter task: Task to add
  func add(_ task: Task) {
    let maxSortOrder = tasks.map({ $0.sortOrder }).max()
    if let maxSortOrder {
      task.sortOrder = maxSortOrder + 1
    }
    tasks.append(task)
  }
  
  /// Removes a task from this checklist
  /// - Parameter task: Task to remove
  func remove(_ task: Task) {
    if let index = tasks.firstIndex(of: task) {
      tasks.remove(at: index)
    }
  }
  
  /// Resets the completion status of tasks
  func reset() {
    for task in tasks {
      task.isCompleted = false
    }
  }
  
  /// Gets the total number of tasks in the checklist
  /// - Parameter modelContext: Model Context checklist is in
  /// - Returns: Total number of tasks
  func taskCount(for modelContext: ModelContext) -> Int {
    (try? modelContext.fetchCount(taskFetchDescriptor)) ?? 0
  }
  
  /// Gets the total number of completed tasks in the checklist
  /// - Parameter modelContext: Model Context checklist is in
  /// - Returns: Total number of completed tasks
  func completedTaskCount(for modelContext: ModelContext) -> Int {
    (try? modelContext.fetchCount(completedTaskFetchDescriptor)) ?? 0
  }
}

// MARK: Fetch Descriptors
extension Checklist {
  /// Descriptor for getting the tasks in the checklist
  var taskFetchDescriptor: FetchDescriptor<Task> {
    let id = self.id
    
    let taskPredicate = #Predicate<Task> { task in
      task.checklist?.id == id
    }
    
    return FetchDescriptor<Task>(predicate: taskPredicate)
  }
  
  /// Descriptor for getting completed tasks in the checklist
  var completedTaskFetchDescriptor: FetchDescriptor<Task> {
    let id = self.id
    
    let completedTaskPredicate = #Predicate<Task> { task in
      task.checklist?.id == id && task.isCompleted
    }
    
    return FetchDescriptor<Task>(predicate: completedTaskPredicate)
  }
}

extension ModelContext {
  /// Deletes a checklist and all of its cascade relationships
  /// Ideally, this wouldn't be needed, but having issue with SwiftData automatically deleting
  /// - Parameter checklist: Checklist to delete
  func delete(checklist: Checklist) {
    for task in checklist.tasks {
      self.delete(task)
    }
    
    self.delete(checklist)
  }
}

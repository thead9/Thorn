//
//  Task.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import Foundation
import SwiftData

@Model
/// A task to complete
class Task: Identifiable, Sortable {
  /// Unique Identifier
  let id: UUID
  
  /// Name of the task
  var name: String
  
  /// Checklist associated with task
  var checklist: Checklist?
  
  /// Sort order in checklist
  var sortOrder: Int = 0
  
  /// Indicates if the task is completed
  var isCompleted: Bool = false
    
  /// Creates a task
  /// - Parameters:
  ///   - named: Name of the task
  init(named name: String) {
    self.id = UUID()
    self.name = name
  }
  
  @discardableResult
  /// Creates a task and adds it to the specified model context
  /// - Parameters:
  ///   - name: Name of the task
  ///   - context: Model context to add the task to
  /// - Returns: The task itself
  static func newItem(
    named name: String,
    for context: ModelContext) -> Task {
      let task = Task(named: name)
      context.insert(task)
      
      return task
    }
}

extension ModelContext {
  /// Deletes a task and all of its cascade relationships
  /// Ideally, this wouldn't be needed, but having issue with SwiftData automatically deleting
  /// - Parameter task: Task to delete
  func delete(task: Task) {
    self.delete(task)
  }
}

//
//  Task.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import SwiftData

@Model
/// A task to complete
class Task {
  /// Name of the task
  var name: String
  
  /// Creates a task
  /// - Parameter name: Name of the task
  init(name: String) {
    self.name = name
  }
  
  @discardableResult
  /// Creates a task and adds it to the specified model context
  /// - Parameters:
  ///   - name: Name of the task
  ///   - context: Model context to add the task to
  /// - Returns: The task itself
  static func newItemForContext(name: String, context: ModelContext) -> Task {
    let task = Task(name: name)
    context.insert(task)
    
    return task
  }
}

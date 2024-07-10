//
//  Feat.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import Foundation
import SwiftData

@Model
/// A task to complete
class Feat: Identifiable, Sortable {
  /// Unique Identifier
  let id: UUID = UUID()
  
  /// Name of the task
  var name: String = "--"
  
  /// The date the checklist was created
  var dateCreated: Date = Date.now
  
  /// Checklist associated with task
  var checklist: Checklist?
  
  /// Sort order in checklist
  var sortOrder: Int = 0
  
  /// Indicates if the task is completed
  var isCompleted: Bool = false
    
  /// Creates a feat
  /// - Parameters:
  ///   - named: Name of the feat
  init(named name: String) {
    self.id = UUID()
    self.name = name
    self.dateCreated = Date.now
  }
  
  @discardableResult
  /// Creates a task and adds it to the specified model context
  /// - Parameters:
  ///   - name: Name of the task
  ///   - context: Model context to add the task to
  /// - Returns: The task itself
  static func newItem(
    named name: String,
    for context: ModelContext) -> Feat {
      let feat = Feat(named: name)
      context.insert(feat)
      
      return feat
    }
}

extension ModelContext {
  /// Deletes a feat and all of its cascade relationships
  /// Ideally, this wouldn't be needed, but having issue with SwiftData automatically deleting
  /// - Parameter feat: Feat to delete
  func delete(feat: Feat) {
    self.delete(feat)
  }
}

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
class Checklist {
  /// Name of the checklist
  var name: String
  
  /// The date the checklist was created
  var dateCreated: Date
  
  /// Tasks associated with this checklist
  var tasks: [Task]
  
  /// Creates a checklist
  /// - Parameter name: Name of the checklist
  init(name: String) {
    self.name = name
    self.dateCreated = Date.now
    self.tasks = [Task]()
  }
  
  @discardableResult
  /// Creates a checklist and adds it to the specified model context
  /// - Parameters:
  ///   - name: Name of the checklist
  ///   - context: Model context to add the checklist to
  /// - Returns: The checklist itself
  static func newItemForContext(name: String, context: ModelContext) -> Checklist {
    let checklist = Checklist(name: name)
    context.insert(checklist)
    
    return checklist
  }
}

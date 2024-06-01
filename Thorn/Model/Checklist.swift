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

  @Relationship(deleteRule: .cascade, inverse: \Feat.checklist)
  /// Tasks associated with this checklist
  var feats: [Feat]
  
  /// Creates a checklist
  /// - Parameter name: Name of the checklist
  init(named name: String) {
    self.id = UUID()
    self.name = name
    self.dateCreated = Date.now
    self.completionCount = 0
    self.feats = [Feat]()
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
  
  /// Adds a feat to this checklist
  /// - Parameter task: Task to add
  func add(_ feat: Feat) {
    let maxSortOrder = feats.map({ $0.sortOrder }).max()
    if let maxSortOrder {
      feat.sortOrder = maxSortOrder + 1
    }
    feats.append(feat)
  }
  
  /// Removes a task from this checklist
  /// - Parameter feat: Task to remove
  func remove(_ feat: Feat) {
    if let index = feats.firstIndex(of: feat) {
      feats.remove(at: index)
    }
  }
  
  /// Resets the completion status of tasks
  func reset() {
    for feat in feats {
      feat.isCompleted = false
    }
  }
  
  func completionCheck() {
    if feats.count > 0 && feats.allSatisfy({ $0.isCompleted }) {
      completionCount += 1
    }
  }
}

// MARK: Predicates
extension Checklist {
  /// Prredicate for getting the tasks in the checklist
  var featsPredicate: Predicate<Feat> {
    let id = self.id
    let predicate = #Predicate<Feat> { feat in
      feat.checklist?.id == id
    }
    
    return predicate
  }
}

extension ModelContext {
  /// Deletes a checklist and all of its cascade relationships
  /// Ideally, this wouldn't be needed, but having issue with SwiftData automatically deleting
  /// - Parameter checklist: Checklist to delete
  func delete(checklist: Checklist) {
    for feat in checklist.feats {
      self.delete(feat)
    }
    
    self.delete(checklist)
  }
  
  func checklistCount() -> Int {
    (try? fetchCount(FetchDescriptor<Checklist>())) ?? 0
  }
}

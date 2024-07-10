//
//  Sortable.swift
//  Thorn
//
//  Created by Thomas Headley on 3/6/24.
//

import Foundation

/// Defines what is needed to be sortable
protocol Sortable {
  /// Indicates the sort order. Lower numbers come first in the order
  var sortOrder: Int { get set }
}

extension Array where Element: Sortable {
  /// Updates the sort order of elements based on their current position
  /// - Parameters:
  ///   - source: An index set representing the offsets of all elements that should be moved.
  ///   - destination: The offset of the element before which to insert the moved elements. destination must be in the closed range 0...count.
  func updateSortOrder(from source: IndexSet, to destination: Int) {
    // Make an array of items from fetched results
    var revisedItems: [Element] = self.map{ $0 }
    
    // change the order of the items in the array
    revisedItems.move(fromOffsets: source, toOffset: destination )
    
    // update the userOrder attribute in revisedItems to
    // persist the new order. This is done in reverse order
    // to minimize changes to the indices.
    var sortOrder = 0
    for reverseIndex in stride( from: revisedItems.count - 1,
                                through: 0,
                                by: -1 ) {
      revisedItems[reverseIndex].sortOrder = sortOrder
      sortOrder += 1
    }
  }
}

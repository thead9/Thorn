//
//  Sortable.swift
//  Thorn
//
//  Created by Thomas Headley on 3/6/24.
//

import Foundation

protocol Sortable {
  var sortOrder: Int { get set }
}

extension Array where Element: Sortable {
  func updateSortOrder(from source: IndexSet, to destination: Int) {
    // Make an array of items from fetched results
    var revisedItems: [Element] = self.map{ $0 }
    
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
  
  func updateSortOrder(around index: Int, for keyPath: WritableKeyPath<Element, Int> = \.sortOrder, spacing: Int = 32, offset: Int = 1, _ operation: @escaping (Int, Int) -> Void) {
    if let enclosingIndices = enclosingIndices(around: index, offset: offset) {
      if let leftIndex = enclosingIndices.first(where: { $0 != index }),
         let rightIndex = enclosingIndices.last(where: { $0 != index }) {
        let left = self[leftIndex][keyPath: keyPath]
        let right = self[rightIndex][keyPath: keyPath]
        
        if left != right && (right - left) % (offset * 2) == 0 {
          let spacing = (right - left) / (offset * 2)
          var sortOrder = left
          for index in enclosingIndices.indices {
            if self[index][keyPath: keyPath] != sortOrder {
              operation(index, sortOrder)
            }
            sortOrder += spacing
          }
        } else {
          updateSortOrder(around: index, for: keyPath, spacing: spacing, offset: offset + 1, operation)
        }
      }
    } else {
      for index in self.indices {
        let sortOrder = index * spacing
        if self[index][keyPath: keyPath] != sortOrder {
          operation(index, sortOrder)
        }
      }
    }
  }
  
  private func enclosingIndices(around index: Int, offset: Int) -> Range<Int>? {
    guard self.count - 1 >= offset * 2 else { return nil }
    var leftIndex = index - offset
    var rightIndex = index + offset
    
    while leftIndex < startIndex {
      leftIndex += 1
      rightIndex += 1
    }
    while rightIndex > endIndex - 1 {
      leftIndex -= 1
      rightIndex -= 1
    }
    
    return Range(leftIndex...rightIndex)
  }
}

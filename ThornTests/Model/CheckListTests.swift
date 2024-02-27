//
//  CheckListTests.swift
//  ThornTests
//
//  Created by Thomas Headley on 2/24/24.
//

import XCTest
import SwiftData
@testable import Thorn

final class CheckListTests: XCTestCase {
  func testInit() {
    func expect(name: String) {
      let before = Date.now
      let checklist = Checklist(name: name)
      let after = Date.now
      
      XCTAssertEqual(name, checklist.name)
      XCTAssertLessThan(before, checklist.dateCreated)
      XCTAssertGreaterThan(after, checklist.dateCreated)
    }
    
    expect(name: "Test")
    expect(name: "123")
  }
  
  @MainActor func testNewItemForContext() throws {
    @MainActor func expect(count: Int) {
      let config = ModelConfiguration(isStoredInMemoryOnly: true)
      let container = try! ModelContainer(for: Checklist.self, configurations: config)
      for x in 1...count {
        Checklist.newItemForContext(name: "\(x)", context: container.mainContext)
      }
      
      let descriptor = FetchDescriptor<Checklist>()
      let checklistCount = try! container.mainContext.fetchCount(descriptor)
      
      XCTAssertEqual(count, checklistCount)
    }
    
    expect(count: 1)
    expect(count: 5)
  }
}

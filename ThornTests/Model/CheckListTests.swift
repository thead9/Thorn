//
//  CheckListTests.swift
//  ThornTests
//
//  Created by Thomas Headley on 2/24/24.
//

import XCTest
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
}

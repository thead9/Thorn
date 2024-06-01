//
//  TaskTests.swift
//  ThornTests
//
//  Created by Thomas Headley on 2/27/24.
//

import XCTest
import SwiftData
@testable import Thorn

final class FeatTests: XCTestCase {
  func testInit() {
    func expect(name: String) {
      let feat = Feat(named: name)
      
      XCTAssertEqual(name, feat.name)
    }
    
    expect(name: "Test")
    expect(name: "123")
  }
  
  @MainActor func testNewItemForContext() throws {
    @MainActor func expect(count: Int) {
      let container = ModelUtilities.getTestModelContainer()
      for x in 1...count {
        Feat.newItem(named: "\(x)", for: container.mainContext)
      }
      
      let descriptor = FetchDescriptor<Feat>()
      let featCount = try! container.mainContext.fetchCount(descriptor)
      
      XCTAssertEqual(count, featCount)
    }
    
    expect(count: 1)
    expect(count: 5)
  }
  
  @MainActor func testDeleteFeat() {
    let container = ModelUtilities.getTestModelContainer()
    let feat = Feat.newItem(named: "name", for: container.mainContext)
    
    container.mainContext.delete(feat: feat)
    
    let featDescriptor = FetchDescriptor<Feat>()
    let featCount = try! container.mainContext.fetchCount(featDescriptor)
    
    XCTAssertEqual(0, featCount)
  }
}

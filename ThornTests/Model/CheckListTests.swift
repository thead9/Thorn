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
      let checklist = Checklist(named: name)
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
        Checklist.newItem(named: "\(x)", for: container.mainContext)
      }
      
      let descriptor = FetchDescriptor<Checklist>()
      let checklistCount = try! container.mainContext.fetchCount(descriptor)
      
      XCTAssertEqual(count, checklistCount)
    }
    
    expect(count: 1)
    expect(count: 5)
  }
  
  @MainActor func testAddFeat() {
    @MainActor func expect(count: Int) {
      let container = ModelUtilities.getTestModelContainer()
      let checklist = Checklist.newItem(named: "name", for: container.mainContext)
      
      for x in 0..<count {
        let task = Feat.newItem(named: "\(x)", for: container.mainContext)
        checklist.add(task)
      }
      
      XCTAssertEqual(count, checklist.feats.count)
    }
    
    expect(count: 0)
    expect(count: 1)
    expect(count: 5)
  }
  
  @MainActor func testRemoveFeat() {
    @MainActor func expect(count: Int) {
      let container = ModelUtilities.getTestModelContainer()
      let checklist = Checklist.newItem(named: "name", for: container.mainContext)
      
      for x in 0..<count {
        let feat = Feat.newItem(named: "\(x)", for: container.mainContext)
        checklist.add(feat)
        checklist.remove(feat)
      }
      
      XCTAssertEqual(0, checklist.feats.count)
      
      
    }
    
    expect(count: 0)
    expect(count: 1)
    expect(count: 5)
  }
  
  @MainActor func testRemoveFeatNotPartOfChecklist() {
    let container = ModelUtilities.getTestModelContainer()
    let checklist = Checklist.newItem(named: "name", for: container.mainContext)
    
    let feat = Feat.newItem(named: "1", for: container.mainContext)
    checklist.add(feat)
    
    let feat2 = Feat.newItem(named: "2", for: container.mainContext)
    checklist.remove(feat)
    
    XCTAssertEqual(1, checklist.feats.count)
  }
  
  @MainActor func testDeleteChecklistWithFeat() {
    let container = ModelUtilities.getTestModelContainer()
    let checklist = Checklist.newItem(named: "name", for: container.mainContext)
    
    let feat = Feat.newItem(named: "feat", for: container.mainContext)
    checklist.add(feat)
    
    container.mainContext.delete(checklist: checklist)
    
    let checklistDescriptor = FetchDescriptor<Checklist>()
    let checklistCount = try! container.mainContext.fetchCount(checklistDescriptor)
    
    XCTAssertEqual(0, checklistCount)
    
    let featDescriptor = FetchDescriptor<Feat>()
    let featCount = try! container.mainContext.fetchCount(featDescriptor)
    
    XCTAssertEqual(0, featCount)
  }
}

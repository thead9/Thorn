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
  
  @MainActor func testAddTask() {
    @MainActor func expect(count: Int) {
      let container = ModelUtilities.getTestModelContainer()
      let checklist = Checklist.newItem(named: "name", for: container.mainContext)
      
      for x in 0..<count {
        let task = Task.newItem(named: "\(x)", for: container.mainContext)
        checklist.add(task)
      }
      
      XCTAssertEqual(count, checklist.tasks.count)
    }
    
    expect(count: 0)
    expect(count: 1)
    expect(count: 5)
  }
  
  @MainActor func testRemoveTask() {
    @MainActor func expect(count: Int) {
      let container = ModelUtilities.getTestModelContainer()
      let checklist = Checklist.newItem(named: "name", for: container.mainContext)
      
      for x in 0..<count {
        let task = Task.newItem(named: "\(x)", for: container.mainContext)
        checklist.add(task)
        checklist.remove(task)
      }
      
      XCTAssertEqual(0, checklist.tasks.count)
      
      
    }
    
    expect(count: 0)
    expect(count: 1)
    expect(count: 5)
  }
  
  @MainActor func testRemoveTaskNotPartOfChecklist() {
    let container = ModelUtilities.getTestModelContainer()
    let checklist = Checklist.newItem(named: "name", for: container.mainContext)
    
    let task = Task.newItem(named: "1", for: container.mainContext)
    checklist.add(task)
    
    let task2 = Task.newItem(named: "2", for: container.mainContext)
    checklist.remove(task2)
    
    XCTAssertEqual(1, checklist.tasks.count)
  }
  
  @MainActor func testDeleteChecklistWithTask() {
    let container = ModelUtilities.getTestModelContainer()
    let checklist = Checklist.newItem(named: "name", for: container.mainContext)
    
    let task = Task.newItem(named: "task", for: container.mainContext)
    checklist.add(task)
    
    container.mainContext.delete(checklist: checklist)
    
    let checklistDescriptor = FetchDescriptor<Checklist>()
    let checklistCount = try! container.mainContext.fetchCount(checklistDescriptor)
    
    XCTAssertEqual(0, checklistCount)
    
    let taskDescriptor = FetchDescriptor<Task>()
    let taskCount = try! container.mainContext.fetchCount(taskDescriptor)
    
    XCTAssertEqual(0, taskCount)
  }
}

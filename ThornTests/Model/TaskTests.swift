//
//  TaskTests.swift
//  ThornTests
//
//  Created by Thomas Headley on 2/27/24.
//

import XCTest
import SwiftData
@testable import Thorn

final class TaskTests: XCTestCase {
  func testInit() {
    func expect(name: String) {
      let task = Task(named: name)
      
      XCTAssertEqual(name, task.name)
    }
    
    expect(name: "Test")
    expect(name: "123")
  }
  
  @MainActor func testNewItemForContext() throws {
    @MainActor func expect(count: Int) {
      let container = ModelUtilities.getTestModelContainer()
      for x in 1...count {
        Task.newItem(named: "\(x)", for: container.mainContext)
      }
      
      let descriptor = FetchDescriptor<Task>()
      let taskCount = try! container.mainContext.fetchCount(descriptor)
      
      XCTAssertEqual(count, taskCount)
    }
    
    expect(count: 1)
    expect(count: 5)
  }
  
  @MainActor func testDeleteTask() {
    let container = ModelUtilities.getTestModelContainer()
    let task = Task.newItem(named: "name", for: container.mainContext)
    
    container.mainContext.delete(task: task)
    
    let taskDescriptor = FetchDescriptor<Task>()
    let taskCount = try! container.mainContext.fetchCount(taskDescriptor)
    
    XCTAssertEqual(0, taskCount)
  }
}

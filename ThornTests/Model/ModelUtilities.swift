//
//  ModelUtilities.swift
//  ThornTests
//
//  Created by Thomas Headley on 3/1/24.
//

import Foundation
import SwiftData

class ModelUtilities {
  static func getTestModelContainer() -> ModelContainer {
    let schema = Schema([
      Checklist.self,
      Task.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }
}

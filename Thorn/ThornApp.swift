//
//  ThornApp.swift
//  Thorn
//
//  Created by Thomas Headley on 2/23/24.
//

import SwiftUI
import SwiftData

@main
struct ThornApp: App {
  @StateObject
  private var purchaseManager = PurchaseManager()
  
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Checklist.self,
      Feat.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
      ThornView()
        .modelContainer(sharedModelContainer)
        .environmentObject(purchaseManager)
        .task {
          await purchaseManager.updatePurchasedProducts()
        }
    }
  }
}

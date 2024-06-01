//
//  ThornView.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import SwiftData
import SwiftUI

/// View for the main navigation structure
struct ThornView: View {
  @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
  
  var body: some View {
    NavigationSplitView(columnVisibility: $columnVisibility) {
      ChecklistsView()
        .navigationTitle("Check & Check")
    } detail: {
      DetailPlaceholderView()
    }
    .navigationSplitViewStyle(.balanced)
  }
}

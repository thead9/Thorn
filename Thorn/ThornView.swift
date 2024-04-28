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
  var body: some View {
    NavigationSplitView {
      ChecklistsView()
        .navigationTitle("Thorn")
    } detail: {
      Text("Select Checklist")
    }
  }
}

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
  /// Selected checklist
  @State var selectedChecklist: Checklist? = nil
  
  var body: some View {
    NavigationSplitView {
      ChecklistsView(selectedChecklist: $selectedChecklist)
    } detail: {
      if let selectedChecklist {
        ChecklistView(checklist: selectedChecklist)
      } else {
        Text("Select Checklist")
      }
    }
  }
}

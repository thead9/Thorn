//
//  ThornView.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import SwiftData
import SwiftUI

struct ThornView: View {
  var body: some View {
    NavigationSplitView {
      ChecklistsView()
    } detail: {
      Text("Please select a Checklist")
    }
  }
}

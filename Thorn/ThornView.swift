//
//  ThornView.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import SwiftData
import SwiftUI

struct ThornView: View {
  @State var selectedChecklist: Checklist? = nil
  @Query private var tasks: [Task]
  var body: some View {
    NavigationSplitView {
//      List {
//        ForEach(tasks, id: \.self) { task in
//          TaskCellView(task: task)
//        }
//      }
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

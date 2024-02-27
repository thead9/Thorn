//
//  ChecklistCellView.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import SwiftUI

struct ChecklistCellView: View {
  var checklist: Checklist
  
  var body: some View {
    NavigationLink {
      Text("\(checklist.name): \(checklist.dateCreated, format: Date.FormatStyle(date: .numeric, time: .standard))")
    } label: {
      Text("\(checklist.name): \(checklist.dateCreated, format: Date.FormatStyle(date: .numeric, time: .standard))")
    }
  }
}

//
//  ChecklistView.swift
//  Thorn
//
//  Created by Thomas Headley on 3/5/24.
//

import SwiftUI

struct ChecklistView: View {
  let checklist: Checklist
  
  var body: some View {
    Text("\(checklist.name): \(checklist.dateCreated, format: Date.FormatStyle(date: .numeric, time: .standard))")
  }
}

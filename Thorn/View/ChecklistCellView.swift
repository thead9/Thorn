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
    Text(checklist.name)
  }
}

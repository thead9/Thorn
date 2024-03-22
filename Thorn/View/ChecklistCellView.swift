//
//  ChecklistCellView.swift
//  Thorn
//
//  Created by Thomas Headley on 2/26/24.
//

import SwiftUI

/// View for a checklist cell in a list
struct ChecklistCellView: View {
  /// Checklist this view is associated with
  var checklist: Checklist
  
  var body: some View {
    Text(checklist.name)
  }
}

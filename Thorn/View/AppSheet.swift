//
//  AppSheet.swift
//  Thorn
//
//  Created by Thomas Headley on 4/26/24.
//

import Firnen
import SwiftUI

enum AppSheet: SheetProvider {
  
  case addChecklist
  case editChecklist(_ checklist: Checklist)
  case settings
  case paywall
  
  var sheet: AnyView {
    NavigationStack {
      switch self {
      case .addChecklist:
        ChecklistModView(.add)
      case .editChecklist(let checklist):
        ChecklistModView(.edit(checklist))
      case .settings:
        SettingsView()
      case .paywall:
        PaywallView()
      }
    }.any()
  }
}

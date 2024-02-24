//
//  Checklist.swift
//  Thorn
//
//  Created by Thomas Headley on 2/23/24.
//

import Foundation
import SwiftData

@Model
class Checklist {
  private(set) var name: String
  private(set) var dateCreated: Date
  private(set) var lastModified: Date
  
  init(name: String) {
    self.name = name
    let now = Date.now
    self.dateCreated = now
    self.lastModified = now
  }
}

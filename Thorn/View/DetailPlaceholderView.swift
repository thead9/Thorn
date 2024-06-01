//
//  DetailPlaceholderView.swift
//  Thorn
//
//  Created by Thomas Headley on 6/1/24.
//

import SwiftUI

struct DetailPlaceholderView: View {
  var body: some View {
    VStack {
      Text("Please select or create a checklist")
        .font(.title)
    }
    .padding()
    .background(Color.accentColor)
    .foregroundStyle(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 15))
    .shadow(radius: 10)
    .padding()
  }
}

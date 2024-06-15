//
//  PaywallView.swift
//  Thorn
//
//  Created by Thomas Headley on 5/8/24.
//

import Firnen
import SwiftUI
import StoreKit

struct PaywallView: View {
  @Environment(\.colorScheme) var colorScheme
  
  private var mixIn: Color { colorScheme == .dark ? .black.mix(with: .white, by: 0.1) : .white }
  
  var body: some View {
    SubscriptionStoreView(groupID: CheckPlus.subscriptionGroupIP) {
      ZStack {
        MeshGradient(
          width: 3,
          height: 3,
          points: [
            .init(0, 0), .init(0.5, 0), .init(1, 0),
            .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
            .init(0, 1), .init(0.5, 1), .init(1, 1)
          ],
          colors: [
            .accentColor.mix(with: mixIn, by: 0.8), .accentColor.mix(with: mixIn, by: 0.6), .accentColor.mix(with: mixIn, by: 0.5),
            .accentColor.mix(with: mixIn, by: 0.6), .accentColor.mix(with: mixIn, by: 0.4), .accentColor.mix(with: mixIn, by: 0.2),
            .accentColor.mix(with: mixIn, by: 0.5), .accentColor.mix(with: mixIn, by: 0.3), .accentColor.mix(with: mixIn, by: 0.1),
          ]
        )
        
        VStack {
          Image(colorScheme == .dark ? .darkGreyWithBlueAccentIcon : .lightGreyWithBlueAccentIcon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .frame(maxWidth: 100, maxHeight: 100)
            .rotationEffect(.degrees(-10))
            .shadow(radius: 15)
            .padding(.bottom, 25)
          
          Text("Check+")
            .font(.title)
          Text("Unlocks all features and supports independent iOS development")
            .padding(.horizontal, 25)
            .multilineTextAlignment(.center)
        }
      }
    }
  }
}

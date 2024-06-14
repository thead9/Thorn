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
  var body: some View {
    SubscriptionStoreView(groupID: CheckPlus.subscriptionGroupIP)
  }
}

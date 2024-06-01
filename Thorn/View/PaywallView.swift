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
  @Environment(\.dismiss) private var dismiss
  @Environment(\.openURL) private var openURL
  @EnvironmentObject private var purchaseManager: PurchaseManager
  
  var body: some View {
    VStack {
      if purchaseManager.hasUnlockedPlus {
        thankYou
      } else {
        paywall
          .task {
            do {
              try await purchaseManager.loadProducts()
            } catch {
              print(error)
            }
          }
      }
    }
    .toolbar { toolbar }
  }
  
  var thankYou: some View {
    VStack {
      Text("Thank you for purchasing Cheers+ and supporting its development!")
        .font(.title)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color.accentColor)
    .foregroundStyle(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 15))
    .shadow(radius: 10)
    .padding()
    .navigationTitle("Thank you!")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  var paywall: some View {
    VStack {
      VStack(spacing: 15) {
        Text("Unlock Cheers+")
          .font(.title)
        
        VStack(alignment: .leading) {
          Label("Unlimited Lists", systemImage: "list.bullet")
          Label("Support Future Development", systemImage: "hammer")
        }
        .font(.title2)
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color.accentColor)
      .foregroundStyle(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 15))
      .shadow(radius: 10)
      .padding()
      
      VStack {
        if let annual = purchaseManager.annual {
          HStack {
            VStack(alignment: .leading) {
              Text("Annual")
              Text("\((annual.price/12).asCurrency()) / month")
                .font(.caption)
            }
            Spacer()
            AsyncButton {
              do {
                try await purchaseManager.purchase(annual)
              } catch {
                print(error)
              }
            } label: {
              Text("\(annual.displayPrice) / year")
                .padding()
            }
            .background(Color.accentColor)
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
          }
          
          Divider()
        }
        
        if let monthly = purchaseManager.monthly {
          HStack {
            Text("Monthly")
            Spacer()
            AsyncButton {
              do {
                try await purchaseManager.purchase(monthly)
              } catch {
                print(error)
              }
            } label: {
              Text("\(monthly.displayPrice) / month")
                .padding()
            }
            .background(Color.accentColor)
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
          }
        }
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color(UIColor.secondarySystemGroupedBackground))
      .clipShape(RoundedRectangle(cornerRadius: 15))
      .shadow(radius: 10)
      .padding()
      
      Spacer()
      
      bottomButtons
        .padding(.bottom)
    }
    .navigationTitle("Unlock Cheers+")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  var bottomButtons: some View {
    HStack {
      Button {
        Task {
          do {
            try await AppStore.sync()
          } catch {
            print(error)
          }
        }
      } label: {
        Text("Restore Purchases")
      }
      
      Text("•")
      
      Button {
        openURL(URL(string: CheckPlus.privacyPolicy)!)
      } label: {
        Text("Privacy Policy")
      }
      
      Text("•")
      
      Button {
        openURL(URL(string: CheckPlus.termsOfUse)!)
      } label: {
        Text("Terms of Use")
      }
    }
  }
  
  @ToolbarContentBuilder var toolbar: some ToolbarContent {
    ToolbarItemGroup(placement: .topBarTrailing) {
      Button {
        dismiss()
      } label: {
        Text("Done")
      }
    }
  }
}

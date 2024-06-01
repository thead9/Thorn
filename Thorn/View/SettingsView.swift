//
//  SettingsView.swift
//  Thorn
//
//  Created by Thomas Headley on 4/30/24.
//

import Firnen
import SwiftUI
import StoreKit

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.openURL) var openURL
  @EnvironmentObject private var purchaseManager: PurchaseManager
  @StateObject private var sheet = SheetContext()

  var body: some View {
    VStack {
      List {
        Section {
          if purchaseManager.hasUnlockedPlus {
            Label("Thank you for purchasing Check+", systemImage: "sparkles")
          } else {
            NavigationLink {
              PaywallView()
            } label: {
              Label("Purchase Check+", systemImage: "sparkles")
            }
          }
        } header: {
          Text("Check+")
        }
        
        Section {
          Button {
            openURL(URL(string: CheckPlus.privacyPolicy)!)
          } label: {
            Label("Privacy", systemImage: "hand.raised.fill")
          }
          
          Button {
            openURL(URL(string: CheckPlus.termsOfUse)!)
          } label: {
            Label("Terms", systemImage: "doc.plaintext.fill")
          }
        } header: {
          Text("Legal")
        }
        
        Section {
          Button {
            Task {
              do {
                try await AppStore.sync()
              } catch {
                print(error)
              }
            }
          } label: {
            Label("Restore Purchases", systemImage: "arrow.uturn.forward")
          }
        }
      }
      
    }
    .navigationTitle("Settings")
    .toolbar { toolbar }
  }
  
  @ToolbarContentBuilder
  private var toolbar: some ToolbarContent {
    ToolbarItemGroup(placement: .topBarTrailing) {
      Button {
        dismiss()
      } label: {
        Text("Done")
      }
    }
  }
}

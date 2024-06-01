//
//  PurchaseManager.swift
//  Thorn
//
//  Created by Thomas Headley on 5/8/24.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {
  private let productIDs = [CheckPlus.monthlyID, CheckPlus.annualID]
  
  @Published private(set) var products: [Product] = []
  @Published private(set) var purchasedProductIDs = Set<String>()
  private var productsLoaded = false
  private var updates: Task<Void, Never>? = nil
  
  var monthly: Product? {
    products.first(where: { product in
      product.id == CheckPlus.monthlyID
    }) ?? nil
  }
  
  var annual: Product? {
    products.first(where: { product in
      product.id == CheckPlus.annualID
    }) ?? nil
  }
  
  init() {
    updates = observeTransactionUpdates()
  }
  
  deinit {
    updates?.cancel()
  }
  
  var hasUnlockedPlus: Bool {
    return !self.purchasedProductIDs.isEmpty
  }
  
  func loadProducts() async throws {
    guard !self.productsLoaded else {
      return
    }
    
    self.products = try await Product.products(for: productIDs)
    self.productsLoaded = true
  }
  
  func purchase(_ product: Product) async throws {
    let result = try await product.purchase()
    
    switch result {
    case .success(let verificationResult):
      switch verificationResult {
      case .unverified(let signedType, _):
        await signedType.finish()
        await updatePurchasedProducts()
      case .verified(let signedType):
        await signedType.finish()
        await updatePurchasedProducts()
      }
    case .userCancelled:
      break
    case .pending:
      break
    @unknown default:
      break
    }
  }
  
  func updatePurchasedProducts() async {
    for await result in Transaction.currentEntitlements {
      guard case .verified(let transaction) = result else {
        continue
      }
      
      if transaction.revocationDate == nil {
        purchasedProductIDs.insert(transaction.productID)
      } else {
        purchasedProductIDs.remove(transaction.productID)
      }
    }
  }
  
  private func observeTransactionUpdates() -> Task<Void, Never> {
    Task(priority: .background) { [unowned self] in
      for await _ in Transaction.updates {
        await updatePurchasedProducts()
      }
    }
  }
}

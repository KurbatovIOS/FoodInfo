//
//  ScanerPresenter.swift
//  FoodInfo
//
//  Created by Kurbatov Artem on 13.06.2023.
//

import UIKit

protocol ScanerPresenterDelegate: AnyObject {
    func productReceived(_ product: Product)
    func showWarningAlert(_ code: String)
}

protocol ScanerPresenterProtocol {
    var delegate: ScanerPresenterDelegate? {get set}
    func findProduct(with code: String)
    func loadImage(for product: Product, complition: @escaping (Data?) -> Void)
}

class ScanerPresenter: ScanerPresenterProtocol {
    
    var delegate: ScanerPresenterDelegate?
    
    func findProduct(with code: String) {
        guard !code.isEmpty else {
            // TODO: Warning
            print("Error")
            return
        }
        FirebaseService.shared.getProduct(code, from: Identifiers.productsCollection) { product in
            guard let product else {
                self.delegate?.showWarningAlert(code)
                return
            }
            self.delegate?.productReceived(product)
        }
    }
    
    func loadImage(for product: Product, complition: @escaping (Data?) -> Void) {
        guard let imageName = product.imageName else { return }
        FirebaseService.shared.getProductImage(imageName) { imageData in
           complition(imageData)
        }
    }
}

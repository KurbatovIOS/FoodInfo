//
//  ProductPresenter.swift
//  FoodInfo
//
//  Created by Kurbatov Artem on 13.06.2023.
//

import Foundation

protocol ProductPresenterDelegate: AnyObject {
    func productesRecieved(_ products: [Product])
}

protocol ProductPresenterProtocol {
    var delegate: ProductPresenterDelegate? {get set}
    func getProducts()
    func loadImage(for product: Product, complition: @escaping (Data?) -> Void)
}

class ProductPresenter: ProductPresenterProtocol {
    var delegate: ProductPresenterDelegate?
    
    func getProducts() {
        FirebaseService.shared.getProducts(from: Identifiers.productsCollection) { products in
            guard let products = products else { return }
            self.delegate?.productesRecieved(products)
        }
    }
    
    func loadImage(for product: Product, complition: @escaping (Data?) -> Void) {
        guard let imageName = product.imageName else { return }
        FirebaseService.shared.getProductImage(imageName) { imageData in
           complition(imageData)
        }
    }
}

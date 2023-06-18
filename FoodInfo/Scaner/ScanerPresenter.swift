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
    func showWarningAlert(title: String, message: String, sourceVC: UIViewController)
}

class ScanerPresenter: ScanerPresenterProtocol {
    
    weak var delegate: ScanerPresenterDelegate?
    
    func findProduct(with code: String) {
        FirebaseService.shared.getProduct(code, from: Identifiers.productsCollection) { product in
            guard let product else {
                self.delegate?.showWarningAlert(code)
                return
            }
            self.delegate?.productReceived(product)
        }
    }
    
    func showWarningAlert(title: String, message: String, sourceVC: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        sourceVC.present(alert, animated: true)
    }
    
    func loadImage(for product: Product, complition: @escaping (Data?) -> Void) {
        guard let imageName = product.imageName else { return }
        FirebaseService.shared.getProductImage(imageName) { imageData in
           complition(imageData)
        }
    }
}

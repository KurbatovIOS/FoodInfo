//
//  AlertService.swift
//  FoodInfo
//
//  Created by Kurbatov Artem on 18.06.2023.
//

import Foundation
import UIKit

class AlertService {
    
    static let shared = AlertService()
    
    private init() {}
    
    func createWarningAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}

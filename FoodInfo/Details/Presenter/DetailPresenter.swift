//
//  DetailPresenter.swift
//  FoodInfo
//
//  Created by Kurbatov Artem on 14.06.2023.
//

import Foundation
import UIKit

protocol DetailsPresenterProtocol {
    func highlightIngredients(_ text: String) -> NSMutableAttributedString
}

class DetailsPresenter: DetailsPresenterProtocol {
    
    private let coreDataService: CategoryServiceProtocol
    private var categories: [[String]] = []
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = CategoryService(coreDataService: coreDataService)
    }
    
    func loadCategories() {
        let categories = coreDataService.loadCategories()
        self.categories = [categories[1], categories[2], categories[0]]
    }
    
    func highlightIngredients(_ text: String) -> NSMutableAttributedString {
        loadCategories()
        let ingredients = text.split(separator: ",")
        var mutableAttributedString = NSMutableAttributedString.init(string: text)
        for ingredient in ingredients {
            defineColor(of: String(ingredient).lowercased(), in: text.lowercased(), &mutableAttributedString)
        }
        return mutableAttributedString
    }
    
    private func defineColor(of textToColor: String, in text: String, _ mutableAttributedString: inout NSMutableAttributedString) {
    outerloop: for i in 0..<categories.count {
        for product in categories[i] {
            if textToColor.contains(product.lowercased()) {
                let range = (text as NSString).range(of: textToColor)
                var color = UIColor.black
                switch i {
                case 0:
                    color = .systemRed
                case 1:
                    color = .systemOrange
                case 2:
                    color = .systemGreen
                default:
                    break
                }
                            
                mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
                break outerloop
            }
        }
    }
    }
}

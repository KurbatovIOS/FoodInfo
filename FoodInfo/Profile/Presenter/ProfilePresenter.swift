//
//  ProfilePresenter.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 24.04.2023.
//

import Foundation

protocol ProfilePresenterProtocol {
    func addProductToSection(_ prodocut: String, _ section: [String], _ sectionName: String) -> [String]
    func loadCategories() -> [[String]]
    func clearCategory(_ categoryTag: Int)
    func deleteProduct(_ productName: String)
    func getCategoryName(_ categoryTag: Int) -> String
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    private let coreDataService: CategoryServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = CategoryService(coreDataService: coreDataService)
    }
    
    func addProductToSection(_ prodocut: String, _ section: [String], _ sectionName: String) -> [String] {
        var newSection = section
        newSection.append(prodocut)
        coreDataService.addProduct(prodocut, to: sectionName)
        return newSection
    }
    
    func loadCategories() -> [[String]] {
        coreDataService.loadCategories()
    }
    
    func deleteProduct(_ productName: String) {
        coreDataService.deleteProduct(productName)
    }
    
    func clearCategory(_ categoryTag: Int) {
        let name = getCategoryName(categoryTag)
        coreDataService.clearCategory(name)
    }
    
    func getCategoryName(_ categoryTag: Int) -> String {
        var categoryName = ""
        switch categoryTag {
        case 0:
            categoryName = SectionNames.favourite.rawValue
        case 1:
            categoryName = SectionNames.prohibited.rawValue
        case 2:
            categoryName = SectionNames.unwanted.rawValue
        default:
            break
        }
        return categoryName
    }
}

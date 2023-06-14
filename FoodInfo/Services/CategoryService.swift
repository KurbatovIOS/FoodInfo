//
//  CategoryService.swift
//  FoodInfo
//
//  Created by Kurbatov Artem on 14.06.2023.
//

import Foundation

protocol CategoryServiceProtocol {
    func loadCategories() -> [[String]]
    func addProduct(_ productName: String, to categoryName: String)
    func deleteProduct(_ productName: String)
    func clearCategory(_ categoryName: String)
}

class CategoryService: CategoryServiceProtocol {
    
    let coreDataService: CoreDataServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
    
    func loadCategories() -> [[String]] {
        do {
            let categoryManagedObject = try coreDataService.fetchCategory()
            var categories: [[String]] = Array(repeating: [], count: 3)
            for object in categoryManagedObject {
                guard
                    let categoryName = object.category,
                    let productName = object.name
                else { return [[]] }
                switch categoryName {
                case SectionNames.favourite.rawValue:
                    categories[0].append(productName)
                case SectionNames.prohibited.rawValue:
                    categories[1].append(productName)
                case SectionNames.unwanted.rawValue:
                    categories[2].append(productName)
                default:
                    break
                }
            }
            return categories
        } catch {
            print(error)
            return [[]]
        }
    }
    
    func addProduct(_ productName: String, to categoryName: String) {
        coreDataService.save { context in
            let categoryManagedObject = DBCategoryManagedObject(context: context)
            categoryManagedObject.category = categoryName
            categoryManagedObject.name = productName
        }
    }
    
    func deleteProduct(_ productName: String) {
        coreDataService.save { context in
            let fetchRequest = DBCategoryManagedObject.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", productName as CVarArg)
            let categoryManagedObject = try context.fetch(fetchRequest).first
            guard let categoryManagedObject else {
                return
            }
            context.delete(categoryManagedObject)
        }
    }
    
    func clearCategory(_ categoryName: String) {
        coreDataService.deleteObjects(from: categoryName)
    }
}

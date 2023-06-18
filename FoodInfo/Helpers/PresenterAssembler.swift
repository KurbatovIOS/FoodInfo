//
//  Assembly.swift
//  FoodInfo
//
//  Created by Kurbatov Artem on 18.06.2023.
//

import Foundation

class PresenterAssembler {
    
    func assemble() -> (productPresenter: ProductPresenter, scanerPresenter: ScanerPresenter, profilePresenter:CategoriesPresenter, coreDataService: CoreDataService) {
        let coreDataService = CoreDataService()
        let productPresenter = ProductPresenter()
        let scanerPresenter = ScanerPresenter()
        let profilePresenter = CategoriesPresenter(coreDataService: coreDataService)
        return (productPresenter, scanerPresenter, profilePresenter, coreDataService)
    }
    
}

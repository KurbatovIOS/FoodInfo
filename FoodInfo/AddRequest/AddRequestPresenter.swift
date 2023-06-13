//
//  AddRequestPresenter.swift
//  FoodInfo
//
//  Created by Kurbatov Artem on 13.06.2023.
//

import Foundation

protocol AddRequestPresenterProtocol {
    func addProductRequest(code: String?, title: String?, ingredients: String?, complition: @escaping (_ isSuccess: Bool) -> Void)
}

class AddRequestPresenter: AddRequestPresenterProtocol {
    
    func addProductRequest(code: String?, title: String?, ingredients: String?, complition: @escaping (_ isSuccess: Bool) -> Void) {
        guard
            let code,
            let title,
            let ingredients
        else {
            complition(false)
            return
        }
        let formatedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        let formatedTitle = title.trimmingCharacters(in: .whitespaces)
        let formatedIngredients = ingredients.trimmingCharacters(in: .whitespaces)
        
        FirebaseService.shared.sendAddProductRequest(code: formatedCode, title: formatedTitle, ingredients: formatedIngredients)
        complition(true)
    }
    
}

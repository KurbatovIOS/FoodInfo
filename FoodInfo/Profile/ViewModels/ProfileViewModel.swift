//
//  ProfileViewModel.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 24.04.2023.
//

import Foundation

class ProfileViewModel {
    
    func addProductToSection(_ prodocut: String, _ section: inout [String]) {
        section.append(prodocut)
    }
    
}

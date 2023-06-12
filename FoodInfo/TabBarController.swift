//
//  TabBarController.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 19.02.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionVC = TabManager.createTab(rootVC: ProductsListViewController(), title: "Продукты", iconName: "fork.knife")
        let scanerVC = TabManager.createTab(rootVC: ScanerViewController(), title: "Сканер", iconName: "barcode.viewfinder")
        let profileVC = TabManager.createTab(rootVC:  ProfileViewController(), title: "Категории", iconName: "list.dash")
    
        setViewControllers([collectionVC, scanerVC, profileVC], animated: true)
    }
}

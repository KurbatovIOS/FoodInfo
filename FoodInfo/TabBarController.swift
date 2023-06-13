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
        let productPresenter = ProductPresenter()
        let scanerPresenter = ScanerPresenter()
        let profilePresenter = ProfilePresenter()
        
        let collectionVC = TabManager.createTab(rootVC: ProductsListViewController(presenter: productPresenter), title: "Продукты", iconName: "cart")
        let scanerVC = TabManager.createTab(rootVC: ScanerViewController(presenter: scanerPresenter), title: "Сканер", iconName: "barcode.viewfinder")
        let profileVC = TabManager.createTab(rootVC:  ProfileViewController(presenter: profilePresenter), title: "Категории", iconName: "list.dash")
    
        setViewControllers([collectionVC, scanerVC, profileVC], animated: true)
    }
}

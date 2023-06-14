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
        let coreDataService = CoreDataService()
        let productPresenter = ProductPresenter()
        let scanerPresenter = ScanerPresenter()
        let profilePresenter = ProfilePresenter(coreDataService: coreDataService)
        
        let collectionVC = TabManager.createTab(rootVC: ProductsListViewController(presenter: productPresenter, coreDataService: coreDataService), title: "Продукты", iconName: "cart")
        let scanerVC = TabManager.createTab(rootVC: ScanerViewController(presenter: scanerPresenter, coreDataService: coreDataService), title: "Сканер", iconName: "barcode.viewfinder")
        let profileVC = TabManager.createTab(rootVC:  ProfileViewController(presenter: profilePresenter), title: "Категории", iconName: "list.dash")
    
        setViewControllers([collectionVC, scanerVC, profileVC], animated: true)
    }
}

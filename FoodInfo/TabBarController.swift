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
        let assembler = PresenterAssembler()
        let presenters = assembler.assemble()
        
        let collectionVC = TabManager.createTab(rootVC: ProductsListViewController(presenter: presenters.productPresenter, coreDataService: presenters.coreDataService), title: "Продукты", iconName: "cart")
        let scanerVC = TabManager.createTab(rootVC: ScanerViewController(presenter: presenters.scanerPresenter, coreDataService: presenters.coreDataService), title: "Сканер", iconName: "barcode.viewfinder")
        let profileVC = TabManager.createTab(rootVC:  CategoriesViewController(presenter: presenters.profilePresenter), title: "Категории", iconName: "list.dash")
    
        setViewControllers([collectionVC, scanerVC, profileVC], animated: true)
    }
}

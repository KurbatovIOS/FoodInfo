//
//  TabManager.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 01.04.2023.
//

import UIKit

class TabManager {
    
    static func createTab(rootVC: UIViewController, title: String, iconName: String) -> UINavigationController {
        let tab = UINavigationController(rootViewController: rootVC)
        tab.tabBarItem.title = title
        tab.tabBarItem.image = UIImage(systemName: iconName)
        return tab
    }
}

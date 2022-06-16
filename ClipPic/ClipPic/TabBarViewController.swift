//
//  TabBarViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/15.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addTabs()
        // Do any additional setup after loading the view.
    }
    
    func addTabs() {
        let homeViewController = HomeViewController()
        let rootViewController = UINavigationController(rootViewController: homeViewController)
        rootViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "Icons_36px_Home_Normal"),
            selectedImage: UIImage(named: "Icons_36px_Home_Selected"))
        
        UITabBar.appearance().barTintColor = .white
        
        viewControllers = [homeViewController]
    }

}

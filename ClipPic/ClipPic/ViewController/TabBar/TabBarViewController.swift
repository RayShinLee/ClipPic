//
//  TabBarViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/15.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addTabs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    func addTabs() {
        let homeViewController = HomeViewController()
        let homeNavigation = UINavigationController(rootViewController: homeViewController)
        homeNavigation.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "Icons_36px_Home_Normal"),
            selectedImage: UIImage(named: "Icons_36px_Home_Selected"))
        
        let searchViewController = SearchViewController()
        let searchNavigation = UINavigationController(rootViewController: searchViewController)
        searchNavigation.tabBarItem = UITabBarItem(
            title: "Search", image: UIImage(named: "Icons_24x_search"), selectedImage: UIImage(named: "Icons_24x_search"))
        
        UITabBar.appearance().barTintColor = .systemBackground
        
        viewControllers = [homeNavigation, searchNavigation]
    }

}

//
//  TabBarViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/15.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Lifecycle
    
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
    }
    
    // MARK: - Methods
    
    func addTabs() {
        let homeViewController = HomeViewController()
        let homeNavigation = UINavigationController(rootViewController: homeViewController)
        homeNavigation.tabBarItem = UITabBarItem(title: "Home",
                                                 image: UIImage(named: "Icons_36px_Home_Normal"),
                                                 selectedImage: UIImage(named: "Icons_36px_Home_Selected"))
        
        let searchViewController = SearchViewController()
        let searchNavigation = UINavigationController(rootViewController: searchViewController)
        searchNavigation.tabBarItem = UITabBarItem(title: "Search",
                                                   image: UIImage(systemName: "magnifyingglass"),
                                                   selectedImage: UIImage(named: "magnifyingglass.fill"))
        
        let searchImageController = ImageSearchViewController()
        let searchImageNavigation = UINavigationController(rootViewController: searchImageController)
        searchNavigation.navigationBar.isHidden = true
        searchImageNavigation.tabBarItem = UITabBarItem(title: "Images",
                                                        image: UIImage(systemName: "photo"),
                                                        selectedImage: UIImage(systemName: "photo.fill"))
        
        let profileController = ProfileViewController()
        let profileNavigation = UINavigationController(rootViewController: profileController)
        profileNavigation.navigationBar.isHidden = true
        profileNavigation.tabBarItem = UITabBarItem(title: "Profile",
                                                    image: UIImage(named: "Icons_36px_Profile_Normal"),
                                                    selectedImage: UIImage(named: "Icons_36px_Profile_Selected"))
        
        UITabBar.appearance().barTintColor = .systemBackground
        
        viewControllers = [homeNavigation, searchNavigation, searchImageNavigation, profileNavigation]
    }
}

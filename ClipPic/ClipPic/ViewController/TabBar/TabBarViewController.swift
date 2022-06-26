//
//  TabBarViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/15.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    let searchBottomSheet = SearchBottomSheet()
    
    // MARK: - UI Properties
    
    let darkView: UIView = {
        let darkView = UIView()
        darkView.translatesAutoresizingMaskIntoConstraints = false
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        darkView.isHidden = true
        return darkView
    }()
    
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
        searchBottomSheet.exitButton.addTarget(self, action: #selector(closeSearchView), for: .touchUpInside)
        setUpDarkView()
    }
    
    // MARK: - Action methods
    
    @objc func closeSearchView() {
        let startPointY = view.bounds.height
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.searchBottomSheet.frame.origin.y = startPointY
        })
        darkView.isHidden = true
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
    
    func setUpDarkView() {
        view.addSubview(darkView)
        darkView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        darkView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        darkView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        darkView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

}

//  MARK: - tabbarController delegate
extension TabBarViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navi = viewController as? UINavigationController,
           let _ = navi.viewControllers.first as? ImageSearchViewController {
                showSearchBottomSheet()
                return true
        } else {
            return false
        }
    }
    
    func showSearchBottomSheet() {
        let startPointY = view.bounds.height
        let finishPointY = startPointY - 202
        searchBottomSheet.frame = CGRect(x: 0, y: finishPointY, width: view.bounds.width, height: 202)
        view.addSubview(searchBottomSheet)
        darkView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.searchBottomSheet.frame.origin.y = finishPointY
        })
    }
}

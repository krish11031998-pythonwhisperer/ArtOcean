//
//  ViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(hexString: "FFFFFF")
        setViewControllers(self.tabs.compactMap({self.tabViewBuilder(tab: $0)}), animated: true)
        tabBar.layer.cornerRadius = 10

        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .appWhiteBackgroundColor
        appearance.selectionIndicatorTintColor = .appBlueColor
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        setupStatusBar()
		addObservers()
    }
    
    private var tabs:[Tabs]{
        return [Tabs.home,Tabs.search,Tabs.statistics,Tabs.profile]
    }
    
    func tabViewBuilder(tab:Tabs) -> UINavigationController{
        switch tab{
            case .home:
                let navView = UINavigationController(rootViewController: HomeViewController())
			navView.tabBarItem = .init(title: "Home", image: .buildCatalogueImage(name: .homeOutline, size: .squared(20)), tag: 1)
                return navView
            case .search:
                let navView = UINavigationController(rootViewController: SearchViewController())
                navView.tabBarItem = .init(title: "Search", image: .buildCatalogueImage(name: .searchOutline, size: .squared(20)), tag: 2)
                return navView
            case .profile:
                let navView = UINavigationController(rootViewController: ProfileViewController())
			navView.tabBarItem = .init(title: "Profile", image: .buildCatalogueImage(name: .userOutline, size: .squared(20)), tag: 3)
                return navView
            case .statistics:
                let navView = UINavigationController(rootViewController: StatisticsViewController())
                navView.tabBarItem = .init(title: "Statistics", image: .buildCatalogueImage(name: .chartSquareBarOutline, size: .squared(20)), tag: 4)
                return navView
        }
    }
	
	func addObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(showArt), name: .showArt, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(showAccount), name: .showAccount, object: nil)
	}
	
	@objc
	func showArt() {
		print("(DEBUG) showArt is called!")
		UIWindow.topMostNavigation?.pushViewController(NFTDetailArtViewController(), animated: true)
	}

	
	@objc
	func showAccount() {
		print("(DEBUG) showArt is called!")
		UIWindow.topMostNavigation?.pushViewController(NewAccountViewController(), animated: true)
	}

}

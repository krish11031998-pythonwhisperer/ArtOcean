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
        
        self.view.backgroundColor = .init(hexString: "FFFFFF")
        self.setViewControllers(self.tabs.compactMap({self.tabViewBuilder(tab: $0)}), animated: true)
        self.tabBar.layer.cornerRadius = 10

        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .appWhiteBackgroundColor
        appearance.selectionIndicatorTintColor = .appBlueColor
        
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        
        self.setupStatusBar()
    }
    
    private var tabs:[Tabs]{
        return [Tabs.home,Tabs.search,Tabs.statistics,Tabs.profile]
    }
    
    func tabViewBuilder(tab:Tabs) -> UINavigationController{
        switch tab{
            case .home:
                let navView = UINavigationController(rootViewController: HomeViewController())
                navView.tabBarItem = .init(title: "Home", image: .init(named: "home")?.resized(.squared(20)), tag: 1)
                return navView
            case .search:
                let navView = UINavigationController(rootViewController: SearchViewController())
                navView.tabBarItem = .init(title: "Search", image: .init(named: "search")?.resized(.squared(20)), tag: 2)
                return navView
            case .profile:
                let navView = UINavigationController(rootViewController: ProfileViewController())
			navView.tabBarItem = .init(title: "Profile", image: .init(named: "user")?.resized(.squared(20)), tag: 3)
                return navView
            case .statistics:
                let navView = UINavigationController(rootViewController: StatisticsViewController())
                navView.tabBarItem = .init(title: "Statistics", image: .init(named: "chart-square-bar")?.resized(.squared(20)), tag: 4)
                return navView
        }
    }

}

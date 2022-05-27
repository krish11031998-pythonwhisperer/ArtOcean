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
        self.tabBar.tintColor = UIColor(hexString: "8D98AF")
        self.tabBar.layer.cornerRadius = 10
        self.tabBar.backgroundColor = .init(hexString: "FFFFFF")

        self.tabBar.standardAppearance.selectionIndicatorTintColor = UIColor(hexString: "2281E3")
        
        self.setupStatusBar()
    }
    
    private var tabs:[Tabs]{
        return [Tabs.home,Tabs.search,Tabs.statistics,Tabs.profile]
    }
    
    func tabViewBuilder(tab:Tabs) -> UINavigationController{
        switch tab{
            case .home:
                let navView = UINavigationController(rootViewController: HomeViewController())
                navView.tabBarItem = .init(title: "Home", image: .init(named: "home"), tag: 1)
                return navView
            case .search:
                let navView = UINavigationController(rootViewController: SearchViewController())
                navView.tabBarItem = .init(title: "Search", image: .init(named: "search"), tag: 2)
                return navView
            case .profile:
                let navView = UINavigationController(rootViewController: ProfileViewController())
                navView.tabBarItem = .init(title: "Profile", image: .init(named: "profile"), tag: 3)
                return navView
            case .statistics:
                let navView = UINavigationController(rootViewController: StatisticsViewController())
                navView.tabBarItem = .init(title: "Statistics", image: .init(named: "statistics"), tag: 4)
                return navView
        }
    }

}


//extension MainTabController:UITabBarDelegate{
//
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        tabBar.items?.forEach({$0.standardAppearance.color})
//    }
//}


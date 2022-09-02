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
		
        setViewControllers(tabs.compactMap(tabViewBuilder(tab:)), animated: true)
		tabBar.cornerRadius(12, at: .top)
		tabBar.tintColor = .purple800
		
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .surfaceBackground
        appearance.selectionIndicatorTintColor = .purple900
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        setupStatusBar()
		addObservers()
		mainTab()
    }
    
	private func mainTab() {
		let plusButton = CustomImageButton(name: .plus, frame: .squared(46), tintColor: .greyscale50, bgColor: .purple900, bordered: true, buttonStyle: .circle(.squared(16))) {
			print("(DEBUG) clicked on Plus!")
		}
		plusButton.frame.origin = .init(x: (.totalWidth - plusButton.compressedFittingSize.width).half, y: -20)
		plusButton.cornerRadius(16, at: .all)
		tabBar.addSubview(plusButton)
	}
	
    private var tabs:[Tabs]{
		return [Tabs.home,Tabs.search,Tabs.add,Tabs.statistics,Tabs.profile]
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
			case .add:
				let navView = UINavigationController(rootViewController: .init())
				navView.tabBarItem = .init(title: nil, image: .solid(color: .clear).resized(.squared(20)), tag: 5)
				navView.tabBarItem.isEnabled = false
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
		UIWindow.topMostNavigation?.pushViewController(AccountViewController(), animated: true)
	}

}

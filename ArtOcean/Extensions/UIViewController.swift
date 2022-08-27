//
//  UIViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 27/05/2022.
//

import UIKit

extension UIViewController{
    
    func setupStatusBar(color:UIColor? = .white){
		let appearance = UINavigationBarAppearance()
		appearance.configureWithTransparentBackground()
		appearance.backgroundColor = color
		appearance.shadowColor = .clear
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
		navigationController?.navigationBar.standardAppearance = appearance
    }
    
	static var safeAreaInset: UIEdgeInsets { UIWindow.safeAreaInset }
	
    func hideNavigationBarLine() {
        guard let navigationBar = self.navigationController?.navigationBar else {return}
        let img = UIImage()
        navigationBar.shadowImage = img
        navigationBar.setBackgroundImage(img, for: .default)
        navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
	
	var navBarOrigin: CGPoint { navigationController?.navigationBar.frame.origin ?? .zero }
    
	var isNavBarHidden: Bool { navigationController?.navigationBar.isHidden ?? false }
	
	func showNavBar() {
		if isNavBarHidden {
			self.navigationController?.setNavigationBarHidden(false, animated: true)
		}
	}
	
	func hideNavBar() {
		if !isNavBarHidden {
			self.navigationController?.setNavigationBarHidden(true, animated: true)
		}
	}
	
	var topMost: UIViewController? {
		switch self {
		case let navigation as UINavigationController:
			return navigation.visibleViewController?.topMost
		case let tab as UITabBarController:
			return tab.selectedViewController?.topMost
		case let presentation where presentedViewController != nil:
			return presentation.presentedViewController?.topMost
		default:
			 return self
		}
	}
}

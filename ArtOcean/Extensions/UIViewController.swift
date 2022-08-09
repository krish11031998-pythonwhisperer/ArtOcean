//
//  UIViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 27/05/2022.
//

import UIKit

extension UIViewController{
    
    func setupStatusBar(color:UIColor = .white){
        let navbarAppearance = UINavigationBarAppearance()
        navbarAppearance.backgroundColor = color
        self.navigationController?.navigationBar.standardAppearance = navbarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navbarAppearance
    }
    
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
}

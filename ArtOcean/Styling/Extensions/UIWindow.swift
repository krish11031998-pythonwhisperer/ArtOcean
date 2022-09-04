//
//  UIWindow.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 20/08/2022.
//

import Foundation
import UIKit

public extension UIApplication {
	
	static var main: UIApplication? { UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication }
}

extension UIWindow {
	
	static var safeAreaInset: UIEdgeInsets { Self.key?.safeAreaInsets ?? .zero }
	
	static var key: UIWindow? {
		guard #available(iOS 13.0, *) else { return Self.key?.window }
		let windows = UIApplication.main?.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.windows
		return windows?.first(where: { $0.isKeyWindow }) ?? windows?.last
	}
	
	static var topMostViewController: UIViewController? {
		key?.rootViewController?.topMost ?? key?.rootViewController
	}
	
	static var topMostNavigation: UINavigationController? {
		let topMost = topMostViewController
		return (topMost as? UINavigationController) ?? topMost?.navigationController
	}
	
}

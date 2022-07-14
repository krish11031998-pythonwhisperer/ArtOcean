//
//  CGFloat.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 11/07/2022.
//

import Foundation
import UIKit

extension CGFloat {
	
	static var totalWidth: CGFloat {
		UIScreen.main.bounds.width
	}
	
	static var totalHeight: CGFloat {
		UIScreen.main.bounds.height
	}
	
	func half() -> Self { self * 0.5 }
	
	func multiple(factor x: CGFloat) -> Self { self * x }
	
}

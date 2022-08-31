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
	
	static var safeAreaTotalHeight: CGFloat {
		guard let safeArea = UIWindow.key?.safeAreaInsets else { return .totalHeight }
		return .totalHeight - (safeArea.top + safeArea.bottom)
	}
	
	var half: Self { self * 0.5 }
	
	func multiple(factor x: CGFloat) -> Self { self * x }
	
	func clampBetween(min:CGFloat,max:CGFloat) -> CGFloat {
		if self <= min {
			return min + max * 0.2
		} else if self >= max {
			return max - max * 0.2
		} else {
			return self
		}
	}
}

extension ClosedRange {
		
	func clamped(_ val:Bound) -> Bound {
		Swift.min(upperBound,Swift.max(lowerBound,val))
	}
	
	
	
}

extension ClosedRange where Bound == CGFloat {
	
	func percent(_ val:Bound,normalizeBelow: CGFloat = 0.001) -> Bound {
		let normVal = normalized(val)
		return normVal > normalizeBelow ? normVal : 0
	}
	
	func normalized(_ val:Bound) -> Bound {
		(clamped(val) - lowerBound)/(upperBound - lowerBound)
	}
}

//
//  CGSize.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 11/07/2022.
//

import Foundation
import UIKit

extension CGSize {
	
	static func squared(_ dimension:CGFloat) -> CGSize {
		return .init(width: dimension, height: dimension)
	}
	
	func halfed() -> CGSize {
		return .init(width: width * 0.5, height: height * 0.5)
	}
	
	static func * (lhs:CGSize,rhs:CGFloat) -> CGSize {
		return .init(width: lhs.width * rhs, height: lhs.height * rhs)
	}
	
}

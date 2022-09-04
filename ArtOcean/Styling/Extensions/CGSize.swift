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
	
	static func * (lhs:CGSize,rhs:CGFloat) -> CGSize {
		return .init(width: lhs.width * rhs, height: lhs.height * rhs)
	}

	var halfed: CGSize { self * 0.5 }
	
	var frame: CGRect { .init(origin: .zero, size: self) }
	
	static var smallestSqaure: CGSize { .squared(32) }
	
}

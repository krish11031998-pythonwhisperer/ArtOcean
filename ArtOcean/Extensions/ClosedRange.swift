//
//  ClosedRange.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 22/08/2022.
//

import Foundation
import UIKit

extension ClosedRange where Bound == CGFloat {
	
	func precent(_ value: Self.Bound) -> Self.Bound {
		let max = upperBound
		let min = lowerBound
		return (value - min)/(max - min)
	}
	
}

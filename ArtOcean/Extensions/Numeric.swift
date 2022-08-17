//
//  Numeric.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 15/07/2022.
//

import Foundation
import UIKit

extension Numeric {
	
	func toString() -> String {
		if let intVal = self as? Int {
			return "\(intVal)"
		} else if let floatVal = self as? Float {
			return String(format: "%.2f", floatVal)
		} else if let doubleVal = self as? Double {
			return String(format: "%.2f", doubleVal)
		} else { return "" }
	}
	
}

extension Array where Element == CGFloat {
	
	var normalized: [CGFloat] {
		guard
			let min = self.min(),
			let max = self.max()
		else { return self }
		
		return map { ($0 - min)/(max - min)}
	}
	
}

extension Array where Element == Double {
	
	var normalized: [Self.Element] {
		guard
			let min = self.min(),
			let max = self.max()
		else { return self }
		
		return map { ($0 - min)/(max - min)}
	}
	
	
}

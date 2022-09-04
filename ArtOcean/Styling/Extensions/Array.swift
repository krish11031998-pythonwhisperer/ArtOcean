//
//  Array.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 22/06/2022.
//

import Foundation
import UIKit

extension Array {
	
	func limit(to: Int) -> [Self.Element] {
		return count <= to ? self : Array(self[0..<to])
	}
	
	func filterEmpty() -> [Self.Element] {
		compactMap { $0 }
	}
	
	func multiDimension(dim: Int) -> [[Self.Element]] {
		var result: [[Self.Element]] = []
		var row: [Self.Element] = []
		for el in self.enumerated() {
			if el.offset != 0 && el.offset % dim == 0 {
				result.append(row)
				row.removeAll()
			}
			row.append(el.element)
		}
		return result
	}
}

//MARK: - Element == CGPoint
extension Array where Element == CGPoint{
    
    func findNearestPoint(_ location:CGPoint) -> CGPoint?{
        if isEmpty { return nil }
		
		var target:CGPoint? = first
		var min:CGFloat = CGFloat(Float.greatestFiniteMagnitude)
		
        for point in self{
            let diff = abs(point.x - location.x)
            if diff < min{
                min = diff
                target = point
            }
        }
        
        return target
    }
    
}

//MARK: - Element:Numeric

extension Array where Element:Numeric{
    
    func square() -> [Self.Element]{
        return map({$0 * $0})
    }
	
	func overallChange() -> Self.Element?{
		guard let safeFirst = self.first,let safeLast = self.last else {return nil}
		return (safeLast - safeFirst)
	}
}



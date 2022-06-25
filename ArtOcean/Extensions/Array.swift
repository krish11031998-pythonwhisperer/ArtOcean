//
//  Array.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 22/06/2022.
//

import Foundation
import UIKit

//MARK: - Element == CGPoint
extension Array where Element == CGPoint{
    
    func findNearestPoint(_ location:CGPoint) -> CGPoint?{
        var target:CGPoint? = nil
        var min:CGFloat = CGFloat(Float.greatestFiniteMagnitude)
        
        if isEmpty { return nil }
        
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



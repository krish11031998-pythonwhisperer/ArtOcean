//
//  UITouch.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 14/07/2022.
//

import Foundation
import UIKit

extension UITouch {
	
	func findDirectionOfTouch(in view:UIView?) {
		let location = location(in: view)
		let prevLocation = previousLocation(in: view)
		
		let deltaX = abs(location.x - prevLocation.x)
		let deltaY = abs(location.y - prevLocation.y)
		let delta = deltaY/deltaX
		if delta < 0.5 {
			print("(DEBUG) Touched Horizontally by : ",delta)
		} else {
			print("(DEBUG) Touched Vertically by : ",delta)
		}
		
	}
	
}

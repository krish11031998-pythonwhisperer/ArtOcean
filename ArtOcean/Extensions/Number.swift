//
//  Number.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 04/07/2022.
//

import Foundation
import UIKit

extension Numeric where Self:Comparable {
	
	func clamp(_ to:Self) -> Self{
		return self > to ? to : self
	}
	
}

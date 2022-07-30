//
//  UIEdgeInsets.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 08/07/2022.
//

import Foundation
import UIKit

extension UIEdgeInsets {
	
	init(vertical:CGFloat,horizontal:CGFloat) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}
	
}

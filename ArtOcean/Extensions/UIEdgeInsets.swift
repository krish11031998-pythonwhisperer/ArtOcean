//
//  UIEdgeInsets.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 08/07/2022.
//

import Foundation
import UIKit

extension UIEdgeInsets {
	
	init(vertical:CGFloat = .zero, horizontal:CGFloat = .zero) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}
	
	var vertical: CGFloat {
		max(top,bottom)
	}
	
	var horizontal: CGFloat {
		max(self.left,self.right)
	}
}

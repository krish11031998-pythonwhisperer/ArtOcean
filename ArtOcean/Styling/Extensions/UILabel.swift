//
//  UILabel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 10/07/2022.
//

import Foundation
import UIKit

public extension UILabel {
	
	func labelCapsule(color:UIColor,cornerRadius:CGFloat) -> UIView {
		let view: UIView = .init()
		view.backgroundColor = color
		view.layer.cornerRadius = cornerRadius
		
		view.addViewAndSetConstraints(self, edgeInsets: .init(vertical: 7.5, horizontal: 10))
		
		
		return view
	}
	
	
}

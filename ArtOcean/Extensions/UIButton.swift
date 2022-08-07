//
//  UIButton.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 07/08/2022.
//

import Foundation
import UIKit

extension UIButton {
	
	static func labelImageButton(imgName: String, title: String) -> UIButton {
		let button = UIButton()
		button.setTitle(title, for: .normal)
		button.titleLabel?.font = CustomFonts.medium.fontBuilder(size: 15)
		button.titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)
		button.setTitleColor(.appBlackColor, for: .normal)
		button.setTitleColor(.appPurpleColor, for: .selected)
		button.setImage(.init(named: imgName)?.resized(.squared(25) * 0.5), for: .normal)
		button.tintColor = .appBlackColor
		return button
	}
	
}

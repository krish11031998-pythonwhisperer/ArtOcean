//
//  ButtonCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 15/08/2022.
//

import Foundation
import UIKit


struct ButtonHandler: ActionProvider {
	var title: RenderableText
	var img: UIImage?
	var configuration: UIButton.Configuration
	var action: Callback?
	
	init(title:RenderableText,
		 img: UIImage? = nil,
		configuration: UIButton.Configuration = .coloredBackground(.appBlueColor),
		action: Callback?) {
		self.title = title
		self.img = img
		self.configuration = configuration
		self.action = action
	}
}

class ButtonViewCell: UIView,ConfigurableStyling {
	
	private lazy var button: CustomLabelButton = {
		CustomLabelButton()
	}()
	
	func prepareCellForReuse() { }
	
	func configureView(with model: ButtonHandler) {
		button.configuration = model.configuration
		button.title = model.title
		button.image = model.img
		addSubview(button)
		button.setHeightWithPriority(40)
		setConstraintsToChild(button, edgeInsets: .init(vertical: 0, horizontal: 10))
		button.isUserInteractionEnabled = false
	}
}

//
//  StackContainer.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/06/2022.
//

import Foundation
import UIKit

class StackContainer:UIStackView{
	
	var headerLabel:UILabel!
	var rightButton:UILabel!
	public var tapHandler:(() -> Void)? = nil
	var innerView:[UIView]
	
	init(
		header:String?,
		rightButtonText:String? = nil,
		axis:NSLayoutConstraint.Axis = .vertical,
		innerView:[UIView]
	) {
		self.innerView = innerView
		super.init(frame: .zero)
		setupUI(header: header, rightButtonText: rightButtonText,axis: axis)
	}
	
	
	convenience init(innerView:[UIView]){
		self.init(header: nil , innerView: innerView)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func setupUI(header:String?,rightButtonText:String? = nil,axis:NSLayoutConstraint.Axis){
		self.axis = axis
		spacing = 8
		
		if let safeHeader = header{
			headerLabel = CustomLabel(text: safeHeader, size: 18, weight: .bold, color: .black, numOfLines: 1)
			addArrangedSubview(headerLabel)
			setCustomSpacing(12, after: headerLabel)
		}
		
		if let rightButtonText = rightButtonText {
			rightButton = CustomLabel(text: rightButtonText, size: 15, weight: .semibold, color: .gray, numOfLines: 1)
			addArrangedSubview(rightButton)
		}
		
		innerView.forEach{addArrangedSubview($0)}
	}
	
}

//
//  CustomLabel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 01/06/2022.
//

import Foundation
import UIKit

enum CustomFonts:String{
    case black = "Satoshi-Black"
    case bold = "Satoshi-Bold"
    case regular = "Satoshi-Regular"
    case medium = "Satoshi-Medium"
    case light = "Satoshi-Light"
    
	func fontBuilder(size: CGFloat) -> UIFont? {
		.init(name: self.rawValue, size: size)
	}
}

class CustomLabel: UILabel{
    init(
        text:String,
        size:CGFloat = 13,
        weight:CustomFonts = .regular,
        color:UIColor,
        numOfLines:Int = 1,
        adjustFontSize:Bool = true,
        autoLayout:Bool = true
    ){
        super.init(frame: .zero)
        self.text = text
		self.font = weight.fontBuilder(size: size)
        self.textColor = color
        self.numberOfLines = numOfLines
        self.adjustsFontSizeToFitWidth = adjustFontSize
        self.translatesAutoresizingMaskIntoConstraints = !autoLayout
    }
	
	init(size: CGSize) {
		super.init(frame: .init(origin: .zero, size: size))
	}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

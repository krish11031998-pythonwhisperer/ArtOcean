//
//  CustomBUtton.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 29/05/2022.
//

import Foundation
import UIKit

@objc protocol CustomButtonDelegate{
    @objc optional func handleTap()
    @objc optional func handleTap(_ data:Any)
}

class CustomLabelButton:UIButton{
    
    var delegate:CustomButtonDelegate? = nil
	var handler: (() -> Void)? {
		didSet { addTarget(self, action: #selector(tapHandler), for: .touchUpInside) }
	}

    init(
		title:String,
		image: UIImage? = nil,
//		font: UIFont? = CustomFonts.regular.fontBuilder(size: 13),
		font: CustomFonts = CustomFonts.regular,
		size: CGFloat = 13,
		color:UIColor = .black,
		backgroundColor:UIColor = .clear,
		frame: CGRect = .zero,
		handler: (() -> Void)? = nil
	) {
		self.handler = handler
        super.init(frame: frame)
		configuration = .coloredBackground(backgroundColor)
		configuration?.attributedTitle = .init(title.styled(font: font, color: color, size: size))
		if let validImage = image {
			configuration?.image = validImage.resized(.squared(15))
		}
        addTarget(self, action: #selector(self.tapHandler), for: .touchUpInside)
		
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapHandler(){
        self.bouncyButtonClick {
			self.delegate?.handleTap?() ?? self.handler?()
        }
    }
	
	public func updateUI(title: RenderableText?, image: UIImage?) {
		if let safeTitle = title {
			safeTitle.renderInto(target: self)
		}
		
		if let safeImage = image {
			setImage(safeImage.resized(.squared(15)), for: .normal)
		}
	}
	
}

extension UIButton.Configuration {
	
	static func coloredBackground(_ color: UIColor = .appBlueColor) -> Self {
		var style = Self.plain()
		style.contentInsets = .init(top: 7.5, leading: 10, bottom: 7.5, trailing: 10)
		style.imagePadding = 5
		
		var background = Self.plain().background
		background.backgroundColor = color
		background.cornerRadius = 14.5
		
		style.background = background
		
		return style
	}
}

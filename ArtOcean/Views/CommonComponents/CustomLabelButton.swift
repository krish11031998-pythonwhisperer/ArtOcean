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
		font: UIFont? = CustomFonts.regular.fontBuilder(size: 13),
		color:UIColor,
		backgroundColor:UIColor = .clear,
		frame: CGRect = .zero,
		handler: (() -> Void)? = nil
	) {
		self.handler = handler
        super.init(frame: frame)
        setTitle(title, for: .normal)
        titleLabel?.font = font
		setTitleColor(color, for: .normal)
		setTitleColor(.appPurpleColor, for: .selected)
		setImage(image?.resized(.squared(15)), for: .normal)
		self.backgroundColor = backgroundColor
		cornerRadius = 14.5
        addTarget(self, action: #selector(self.tapHandler), for: .touchUpInside)
		configuration = nil
		contentEdgeInsets = .init(top: 7.5, left: 10, bottom: 7.5, right: 10)
		titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapHandler(){
        self.bouncyButtonClick {
			self.delegate?.handleTap?() ?? self.handler?()
        }
    }
    
}

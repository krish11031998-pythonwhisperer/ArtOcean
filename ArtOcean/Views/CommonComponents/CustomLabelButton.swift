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
    
    init(title:String,color:UIColor,backgroundColor:UIColor = .clear,frame: CGRect = .zero) {
        super.init(frame: frame)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .init(name: "Satoshi-Medium", size: 13)
        self.titleLabel?.textColor = color
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.backgroundColor = backgroundColor
		self.layer.cornerRadius = 14.5
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(self, action: #selector(self.tapHandler), for: .touchUpInside)
		configuration = nil
		contentEdgeInsets = .init(top: 7.5, left: 10, bottom: 7.5, right: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapHandler(){
        self.bouncyButtonClick {
            self.delegate?.handleTap?()
        }
    }
    
}

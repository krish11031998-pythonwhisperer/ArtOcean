//
//  CustomBackButton.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

class CustomButton:UIView{
    
    public var handler:(() -> Void)?
    
    static var backButton:CustomButton = .init(systemName: "chevron.left")
    static var plusButton:CustomButton = .init(frame: .init(origin: .zero, size: .init(width: 28, height: 28)),name:"plus",autolayout: true)
    static var minusButton:CustomButton = .init(frame: .init(origin: .zero, size: .init(width: 28, height: 28)),name: "minus",autolayout: true)
    static var ethButton:CustomButton = .init(frame: .init(origin: .zero, size: .init(width: 28, height: 28)),name: "eth",autolayout: true)
    
    init(frame:CGRect = .init(origin: .zero, size: .init(width:30,height:30)),cornerRadius:CGFloat = 15,systemName:String? = nil,name:String? = nil,handler:(() -> Void)? = nil,autolayout:Bool = false){
        
        self.handler = handler
        
        super.init(frame: frame)
        
        self.setupView(cornerRadius: cornerRadius)
        
        let buttonView = self.buttonViewBuilder(systemName: systemName, name: name)
        self.addSubview(buttonView)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlerSelector)))
    
        self.translatesAutoresizingMaskIntoConstraints = !autolayout
        
//        if autolayout{
            buttonView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            buttonView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func buttonViewBuilder(systemName:String?,name:String?) -> UIView{
        let buttonView = UIImageView()
        if let safeSystemName = systemName{
            buttonView.image = .init(systemName: safeSystemName,withConfiguration:UIImage.SymbolConfiguration(pointSize: 12, weight: .bold))
        }else if let safeName = name{
            buttonView.image = .init(named: safeName)
            buttonView.contentMode = .scaleAspectFill
        }
        
        buttonView.tintColor = .appBlackColor
        
        buttonView.frame.size = .init(width: 12, height: 12)
        buttonView.frame.origin = .init(x: self.frame.midX - buttonView.frame.width * 0.5, y: self.frame.midY - buttonView.frame.height * 0.5)
        
        return buttonView
    }
    
    func setupView(cornerRadius:CGFloat){
        self.layer.borderColor = UIColor.appGrayColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = .appWhiteBackgroundColor
        
    }
    
    @objc func handlerSelector(){
        self.handler?()
    }
    
}

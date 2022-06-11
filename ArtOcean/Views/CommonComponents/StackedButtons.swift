//
//  StackedButtons.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 11/06/2022.
//

import Foundation
import UIKit

class StackedButtons:UIView{
    
    var buttons:[StackableButton]!
    
    private let stack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(stackableButtons:[StackableButton]) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.buttons = stackableButtons
    }
    
    override func layoutSubviews() {
        for button in buttons{
            stack.addArrangedSubview(button)
        }
        addSubview(stack)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLayout(){
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}

class StackableButton:UIStackView{
    
    public var handleTap:(() -> Void)? = nil
    
    private let imageView:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let imageBackground:UIView = {
        let view = UIView()
        view.frame.size = .init(width: 55, height: 55)
        view.layer.cornerRadius = 27.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var buttonName:CustomLabel? = nil
        
    init(buttonImage:String,buttonName:String? = nil,buttonColor:UIColor,textColor:UIColor? = nil,handleTap: (() -> Void)? = nil){
        self.handleTap = handleTap
        super.init(frame: .zero)
        
        self.axis = .vertical
        self.spacing = 8
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapHandler)))
        
        if let buttonName = buttonName,let textColor = textColor {
            self.setupButtonLabel(buttonName: buttonName, textColor: textColor)
        }
        imageBackground.backgroundColor = buttonColor.withAlphaComponent(0.5)
        imageBackground.layer.borderColor = buttonColor.cgColor
        imageView.image = .init(named: buttonImage)?.withTintColor(.appPurpleColor)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        imageBackground.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: imageBackground.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageBackground.centerYAnchor).isActive = true

        self.addArrangedSubview(imageBackground)
        
        imageBackground.widthAnchor.constraint(equalToConstant: 55).isActive = true
        imageBackground.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        if let safebuttonName = self.buttonName{
            self.addArrangedSubview(safebuttonName)
        }

    }
    
    func setupButtonLabel(buttonName:String,textColor:UIColor){
        self.buttonName = CustomLabel(text: buttonName, size: 14, weight: .medium, color: textColor, numOfLines: 1, adjustFontSize: true, autoLayout: false)
        self.buttonName?.textAlignment = .center
    }
    
    override var intrinsicContentSize: CGSize{
        return .init(width: 55, height: 85)
    }
    
    @objc func onTapHandler(){
        self.bouncyButtonClick()
        self.handleTap?()
    }
}

extension StackableButton{
    
    static var receiveButton:StackableButton = .init(buttonImage: "arrow-down",buttonName: "Receive", buttonColor:.appPurple50Color,textColor: .appPurpleColor) {
        print("(DEBUG) clicked on receive")
    }
    
    static var buyButton:StackableButton = .init(buttonImage: "credit-card",buttonName: "Buy", buttonColor:.appPurple50Color,textColor: .appPurpleColor) {
        print("(DEBUG) clicked on buy")
    }
    
    static var sendButton:StackableButton = .init(buttonImage: "arrow-up-right",buttonName: "Send", buttonColor:.appPurple50Color,textColor: .appPurpleColor) {
        print("(DEBUG) clicked on send")
    }
    
    static var swapButton:StackableButton = .init(buttonImage: "switch-horizontal",buttonName: "Swap", buttonColor:.appPurple50Color,textColor: .appPurpleColor) {
        print("(DEBUG) clicked on swap")
    }
    
}


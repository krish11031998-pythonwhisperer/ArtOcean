//
//  ContainerHeaderView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/05/2022.
//

import UIKit

class ContainerHeaderView: UIView {

    private var buttonHandler:(() -> Void)? = nil
    private var includeButton:Bool = false
    
    private lazy var headerLabel:UILabel = self.labelBuilder(text: "Live Bidding", size: 16, weight: .bold, color: .black, numOfLines: 1)
    
    private lazy var rightButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.titleLabel?.font = .init(name: "Satoshi-Medium", size: 14)
        button.setTitleColor(UIColor.appGrayColor, for: .normal)
        button.setTitleColor(UIColor.appBlackColor, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.handlerButtonClick), for: .touchUpInside)
        return button
    }()
    
    @objc func handlerButtonClick(){
        print("(DEBUG) Clicked on the Button")
        self.buttonHandler?()
    }
    
    
    init(title:String,rightButtonTitle:String?,buttonHandler:(() -> Void)?){
        
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.headerLabel.text = title
        
        if let safeRightButtonTitle = rightButtonTitle{
            self.rightButton.setTitle(safeRightButtonTitle, for: .normal)
            self.includeButton = true
        }
        
        self.buttonHandler = buttonHandler
        
        self.setupView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(self.headerLabel)
        
        if self.includeButton{
            self.addSubview(self.rightButton)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    func setupLayout(){
                
        //titleLabel
        self.headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.headerLabel.widthAnchor.constraint(equalToConstant: self.frame.width * 0.7).isActive = true
        self.headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    
        //rightButton
        if self.includeButton{
            self.rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            self.rightButton.widthAnchor.constraint(equalToConstant: self.frame.width * 0.2).isActive = true
            self.rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            self.rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
//        //view
        self.heightAnchor.constraint(equalToConstant: max(self.headerLabel.intrinsicContentSize.height,self.rightButton.intrinsicContentSize.height)).isActive = true
        
    }

}

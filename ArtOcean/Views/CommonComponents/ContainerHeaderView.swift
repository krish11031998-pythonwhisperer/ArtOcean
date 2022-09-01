//
//  ContainerHeaderView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/05/2022.
//

import UIKit

class ContainerHeaderView: UIView{

    private var buttonHandler:(() -> Void)? = nil
    private var includeButton:Bool = false
    
    private lazy var headerLabel:UILabel = self.labelBuilder(text: "Live Bidding", size: 16, weight: .bold, color: .textColor, numOfLines: 1)
    
    private lazy var rightButton:UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .init(name: "Satoshi-Medium", size: 14)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(UIColor.appGrayColor, for: .normal)
        button.setTitleColor(UIColor.appBlackColor, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.handlerButtonClick), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            button.titleLabel!.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            button.titleLabel!.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
        
        return button
    }()
    
    @objc func handlerButtonClick(){
        print("(DEBUG) Clicked on the Button")
        self.buttonHandler?()
    }
    
    
    init(title:String,rightButtonTitle:String?,buttonHandler:(() -> Void)?){
        
		super.init(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 50)))
		
        self.headerLabel.text = title
        
        if let safeRightButtonTitle = rightButtonTitle{
            self.rightButton.setTitle(safeRightButtonTitle, for: .normal)
            self.includeButton = true
        }
        
        self.buttonHandler = buttonHandler
        
        self.setupView()
    }
    
	convenience init(title:String){
		self.init(title: title, rightButtonTitle: nil, buttonHandler: nil)
	}
	
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.spacing = 5
		stack.addArrangedSubview(self.headerLabel)
        
        //LayoutConstraint
		headerLabel.setContentCompressionResistancePriority(.init(rawValue: 249), for: .horizontal)
		headerLabel.setContentHuggingPriority(.init(rawValue: 749), for: .horizontal)
        if includeButton{
			stack.addArrangedSubview(self.rightButton)
            rightButton.titleLabel?.textAlignment = .right
        }
		addSubview(stack)
		setConstraintsToChild(stack, edgeInsets: .init(top: 12, left: 16, bottom: 12, right: 16))

		
    }
    

}

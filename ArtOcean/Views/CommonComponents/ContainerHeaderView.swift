//
//  ContainerHeaderView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/05/2022.
//

import UIKit

class ContainerHeaderView: UIStackView {

    private var buttonHandler:(() -> Void)? = nil
    private var includeButton:Bool = false
    
    private lazy var headerLabel:UILabel = self.labelBuilder(text: "Live Bidding", size: 16, weight: .bold, color: .black, numOfLines: 1)
    
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
        
        super.init(frame: .zero)
		
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
    
    override var intrinsicContentSize: CGSize{
		return .init(width: UIScreen.main.bounds.width, height: 50)
    }
    
    func setupView(){
        axis = .horizontal
        spacing = 5
        addArrangedSubview(self.headerLabel)
		isLayoutMarginsRelativeArrangement = true
		layoutMargins = .init(top: 10, left: 16, bottom: 10, right: 16)
        
        //LayoutConstraint
		headerLabel.setContentCompressionResistancePriority(.init(rawValue: 249), for: .horizontal)
		headerLabel.setContentHuggingPriority(.init(rawValue: 749), for: .horizontal)
        if includeButton{
			addArrangedSubview(self.rightButton)
            rightButton.titleLabel?.textAlignment = .right
        }
    }
    

}

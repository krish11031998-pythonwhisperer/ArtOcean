//
//  NFTBidController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

class NFTBiddingController:UIView{
    
    
    private lazy var priceLabelView:UILabel = self.labelBuilder(text: "32.06 ETH", size: 24, weight: .bold, color: .black, numOfLines: 1,adjustFontSize: false)
    
    private lazy var balanceView:UILabel = self.labelBuilder(text: "Balance: 0.1345", size: 14, weight: .medium, color: .appGrayColor, numOfLines: 1)
    
    private lazy var priceView:UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        
        let ethButton = CustomButton.ethButton
        stack.addArrangedSubview(ethButton)
        stack.addArrangedSubview(self.priceLabelView)
        
        NSLayoutConstraint.activate([
			ethButton.widthAnchor.constraint(equalToConstant: 28),
			ethButton.heightAnchor.constraint(equalToConstant: 28),
        ])
        
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        self.translatesAutoresizingMaskIntoConstraints = false
        let plusButton = CustomButton.plusButton
        let minusButton = CustomButton.minusButton
        self.addSubview(plusButton)
        self.addSubview(self.priceView)
        self.addSubview(minusButton)
        self.accessibilityIdentifier = "placeBidModalplaceBidController"
        
        
        NSLayoutConstraint.activate([
            minusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            minusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.priceView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.priceView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
		
        self.layer.borderColor = UIColor.appBlueColor.withAlphaComponent(0.125).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 16
        
    }
    
    override var intrinsicContentSize: CGSize{
        return .init(width: UIScreen.main.bounds.width, height: 82)
    }
}

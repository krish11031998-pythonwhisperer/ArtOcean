//
//  NFTBiddingModal.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

class NFTBiddingView:UIView{
   
    public var delegate:CustomButtonDelegate? = nil
    
    //MARK: - Views
    private lazy var modalTitle:UILabel = {
        let label = self.labelBuilder(text: "Place a bid", size: 18, weight: .bold, color: .black, numOfLines: 1)
        return label
    }()
        
    private lazy var balanceView:UILabel = self.labelBuilder(text: "Balance: 0.1345", size: 14, weight: .medium, color: .appGrayColor, numOfLines: 1)
    
    private lazy var biddingView:NFTBiddingController = {
        let biddingController = NFTBiddingController()
        return biddingController
    }()
    
    private lazy var placeBidButton:CustomLabelButton = {
        let button = CustomLabelButton(title: "Place a bid", color: .white, backgroundColor: .appBlueColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var closeButton:CustomButton = {
        let button = CustomButton(systemName: "cross", handler: {
            print("(DEBUG) Close Button closed!")
            self.delegate?.handleTap()
        }, autolayout: true)
        return button
    }()
    
    //MARK: - View Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.modalTitle)
        
        self.addSubview(self.biddingView)
        
        self.addSubview(self.balanceView)
        
        self.addSubview(self.placeBidButton)
        
        self.addSubview(self.closeButton)
        
        self.backgroundColor = .yellow
        self.layer.cornerRadius = 16
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        
        //Title
        self.modalTitle.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 3).isActive = true
        self.modalTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //biddingView
        self.biddingView.topAnchor.constraint(equalToSystemSpacingBelow: self.modalTitle.bottomAnchor, multiplier: 3).isActive = true
        self.biddingView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.biddingView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 3).isActive = true
        self.trailingAnchor.constraint(equalToSystemSpacingAfter: self.biddingView.trailingAnchor, multiplier: 3).isActive = true
        self.biddingView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        //balanceView
        self.balanceView.topAnchor.constraint(equalToSystemSpacingBelow: self.biddingView.bottomAnchor, multiplier: 2).isActive = true
        self.balanceView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //placeBidButton
        self.placeBidButton.topAnchor.constraint(equalToSystemSpacingBelow: self.balanceView.bottomAnchor, multiplier: 3).isActive = true
        self.placeBidButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.placeBidButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70).isActive = true
        self.placeBidButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -70).isActive = true
        self.placeBidButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //closeButton
        self.closeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
}

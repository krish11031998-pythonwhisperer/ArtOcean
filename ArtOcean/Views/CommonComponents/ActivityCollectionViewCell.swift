//
//  ActivityCollectionViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 03/06/2022.
//

import Foundation
import UIKit

class StatisticActivityCollectionViewCell:UICollectionViewCell{
    
    private var offer:NFTArtOffer? = nil
    
    private lazy var imageView:CustomImageView = CustomImageView(cornerRadius: 20)
    
    public var buttonDelegate:CustomButtonDelegate? = nil
    
    //UserInfo
    private lazy var name:UILabel = CustomLabel(text: "Shapire Cole", size: 14, weight: .medium, color: .appBlackColor, numOfLines: 1, adjustFontSize: true)
    
    private lazy var userName:UILabel = CustomLabel(text: "@shpre", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1, adjustFontSize: true)
    
    private lazy var userInfoView:UIStackView = UIView.StackBuilder(views: [name,userName], ratios: [0.5,0.5], spacing: 5, axis: .vertical)
    
    //PricePercentInfo
    private lazy var transactionTypeLabel:UILabel = CustomLabel(text: "Sale", size: 14, weight: .medium, color: .appGreenColor, numOfLines: 1, adjustFontSize: true)
    
    private lazy var transactionTimeLabel:UILabel = CustomLabel(text: "2 minutes ago", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1, adjustFontSize: true)
    
    private lazy var transactionLabel:UIStackView = UIView.StackBuilder(views: [transactionTypeLabel,transactionTimeLabel], ratios: [0.5,0.5], spacing: 5, axis: .vertical)
    
    //MainStackView
    private lazy var stack:UIStackView = {
        let stack = UIView.StackBuilder(views: [userInfoView,transactionLabel], ratios: [0.5,0.5], spacing: 10, axis: .horizontal)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.transactionTypeLabel.textAlignment = .right
        self.transactionTimeLabel.textAlignment = .right
        
        self.addSubview(imageView)
        self.addSubview(stack)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        
        self.imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.backgroundColor = .black
        self.imageView.layer.cornerRadius = 8
        
        self.stack.leadingAnchor.constraint(equalToSystemSpacingAfter: self.imageView.trailingAnchor, multiplier: 1.5).isActive = true
        self.stack.topAnchor.constraint(equalTo: self.topAnchor,constant: 2.5).isActive = true
        self.stack.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -2.5).isActive = true
        self.stack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    @objc func handleTap(){
//        self.bouncyButtonClick()
        self.buttonDelegate?.handleTap?(self.offer as Any)
    }
}


//MARK: - ConfigurableCell

extension StatisticActivityCollectionViewCell:ConfirgurableCell{
    func configure(_ data: Item) {
        switch data{
            case .offer(let offer):
            self.offer = offer
            DispatchQueue.main.async {
                if let title = offer.name,title != ""{
                    self.name.text = title
                }else{
                    self.name.text = "XXXXXX"
                }
                if let imageURL = offer.image,imageURL != ""{
                    self.imageView.updateImageView(url: imageURL)
                }
                
                if let time = offer.time{
                    self.transactionTimeLabel.text = "\(time) minutes ago"
                }
            }
            default:
                print("(DEBUG) user not provided!")
        }
    }
    
    
    static var identifier:String = "StatisticActivityCollectionViewCell"
}

//MARK: - ConfigurableCollectionCell

extension StatisticActivityCollectionViewCell:Configurable{
	
	func configureCell(with model: Item) {
		switch model{
			case .offer(let offer):
			self.offer = offer
			DispatchQueue.main.async {
				if let title = offer.name,title != ""{
					self.name.text = title
				}else{
					self.name.text = "XXXXXX"
				}
				if let imageURL = offer.image,imageURL != ""{
					self.imageView.updateImageView(url: imageURL)
				}
				
				if let time = offer.time{
					self.transactionTimeLabel.text = "\(time) minutes ago"
				}
			}
			default:
				print("(DEBUG) user not provided!")
		}
	}
}

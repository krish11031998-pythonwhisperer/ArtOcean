//
//  TopSellerCollectionCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 31/05/2022.
//

import Foundation
import UIKit

struct TopSellerCollectionViewData: ActionProvider {
	let seller: SellerData
	let action: Callback?
}


class TopSellerCollectionViewCell:UICollectionViewCell{
    
    public static var identifier = "TopSellerCollectionView"
    
    private var seller:SellerData? = nil
    
    private lazy var imageView:CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 15)
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel:UILabel = self.labelBuilder(text: "", size: 14, weight: .medium, color: .black, numOfLines: 1)
    
    private lazy var percentLabel:UILabel = self.labelBuilder(text: "23.5", size: 12, weight: .medium, color: .appGreenColor, numOfLines: 1, adjustFontSize: true)
    
    private lazy var namePercentLabelStack:UIStackView = {
        let stack = UIView.StackBuilder(views: [self.nameLabel,self.percentLabel], ratios: [0.5,0.5], spacing: 2, axis: .vertical)
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.imageView)
        addSubview(self.namePercentLabelStack)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateUI(_ seller:SellerData){
        self.seller = seller
        
        if seller.image != ""{
            self.imageView.updateImageView(url: seller.image)
        }
        
        DispatchQueue.main.async {
            self.nameLabel.text = seller.name
        }
    
    }
    
    func setupLayout(){
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.imageView.layer.cornerRadius = 16
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.namePercentLabelStack.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 12).isActive = true
        self.namePercentLabelStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.namePercentLabelStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.namePercentLabelStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

//MARK: - Configurable
extension TopSellerCollectionViewCell: Configurable {
	func configureCell(with model: TopSellerCollectionViewData) {
		updateUI(model.seller)
	}

	static var itemSize: CGSize {
		.init(width: 125, height: 42)
	}
	
}

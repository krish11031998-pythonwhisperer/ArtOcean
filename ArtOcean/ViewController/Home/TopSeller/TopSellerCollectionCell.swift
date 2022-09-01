//
//  TopSellerCollectionCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 31/05/2022.
//

import Foundation
import UIKit

struct SellerData{
	var name:String
	var image:String
	var percent:Float

	static var test:SellerData = .init(name: "Shapire Cole", image: "", percent: Float.random(in: 1...15))
}

struct TopSellerCollectionViewData: ActionProvider {
	let seller: SellerData
	let action: Callback?
}


class TopSellerCollectionViewCell:UICollectionViewCell{
    
    public static var identifier = "TopSellerCollectionView"
    
    private var seller:SellerData? = nil
    
	private lazy var mainStack: UIStackView = { .HStack(views: [imageView, namePercentLabel], spacing: 12, aligmment: .center) }()
	
    private lazy var imageView:CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 15)
		imageView.image = .loadingBackgroundImage
        return imageView
    }()
    
    private lazy var nameLabel:UILabel = self.labelBuilder(text: "", size: 14, weight: .medium, color: .textColor, numOfLines: 1)
    
    private lazy var percentLabel:UILabel = self.labelBuilder(text: "23.5", size: 12, weight: .medium, color: .appGreenColor, numOfLines: 1, adjustFontSize: true)
    
	private lazy var namePercentLabel: HeaderCaptionLabel = {
		let label: HeaderCaptionLabel = .init()
		return label
	}()
	
    private lazy var namePercentLabelStack:UIStackView = {
		let stack: UIStackView = .VStack(views: [nameLabel, percentLabel], spacing: 2) //UIView.StackBuilder(views: [self.nameLabel,self.percentLabel], ratios: [0.5,0.5], spacing: 2, axis: .vertical)
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		addSubview(mainStack)
		setConstraintsToChild(mainStack, edgeInsets: .zero)
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
        
//        DispatchQueue.main.async {
//            self.nameLabel.text = seller.name
//        }
		namePercentLabel.configureLabel(title: seller.name.body2Medium(), subTitle: "23.5".body3Medium(color: .appGreen))
    
    }
    
    func setupLayout(){
		imageView.setFrameConstraints(size: .squared(32), withPriority: .required)
		imageView.cornerRadius(16, at: .all)
    }
    
}

//MARK: - Configurable
extension TopSellerCollectionViewCell: Configurable {
	func configureCell(with model: TopSellerCollectionViewData) {
		updateUI(model.seller)
	}
}

//MARK: - Layout
extension TopSellerCollectionViewCell {
	static var layout: UICollectionViewFlowLayout {
		return .init(
			itemSize: .init(width: 125, height: 42),
			scrollDirection: .horizontal,
			sectionInset: .init(vertical: .zero, horizontal: 16),
			interitemSpacing: 12,
			lineSpacing: 24
		)
	}
}

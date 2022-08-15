//
//  ActivityCollectionViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 03/06/2022.
//

import Foundation
import UIKit

fileprivate extension NFTArtOffer {
	
	var parseCustomInfoButtonModel: CustomInfoButtonModel {
		let title = (name ?? "XXX").replace().styled(font: .medium, color: .appBlackColor, size: 14)
		let subTitle = "@\(nft?.metadata?.compiler ?? "X")".styled(font: .medium, color: .appGrayColor, size: 12)
		let infoTitle = "2 minutes ago".styled(font: .medium, color: .appGrayColor, size: 12)
		let infoSubTitle = "Sale".styled(font: .medium, color: .appGreenColor, size: 14)
		let size: CGSize = .squared(40)
		let imgUrl = image ?? ""
		return .init(title: title,
					 subTitle: subTitle,
					 infoTitle: infoTitle,
					 infoSubTitle: infoSubTitle,
					 leadingImageUrl: imgUrl,
					 style: .rounded,
					 imgSize: size
		)
	}
	
}

class StatisticActivityCollectionViewCell:UICollectionViewCell{
    
    private var offer:NFTArtOffer? = nil
    
	private lazy var button: CustomInfoButton = {
		CustomInfoButton()
	}()
	
    public var buttonDelegate:CustomButtonDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
		contentView.addSubview(button)
		contentView.setConstraintsToChild(button, edgeInsets: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap(){
        self.buttonDelegate?.handleTap?(self.offer as Any)
    }
	
	private func updateUI(offer: NFTArtOffer? = nil) {
		guard let validOffer = offer else { return }
		self.offer = validOffer
		button.updateUIButton(validOffer.parseCustomInfoButtonModel)
	}
	
	internal override func prepareForReuse() {
		super.prepareForReuse()
		button.leadingImage = .loadingBackgroundImage.roundedImage(cornerRadius: 8)
	}
}


//MARK: - ConfigurableCell

extension StatisticActivityCollectionViewCell:ConfirgurableCell{
    func configure(_ data: Item) {
        switch data{
            case .offer(let offer):
				updateUI(offer: offer)
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
				updateUI(offer: offer)
			default:
				print("(DEBUG) user not provided!")
		}
	}
}

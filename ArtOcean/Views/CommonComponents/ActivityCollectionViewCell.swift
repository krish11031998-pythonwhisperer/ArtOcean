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
    
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: .init(origin: .zero, size: .squared(40)))
		imageView.contentMode = .scaleAspectFill
		imageView.image = .solid(color: .appGrayColor, frame: .squared(40))
		imageView.cornerRadius = 8
		imageView.clipsToBounds = true
		return imageView
	}()
    
    public var buttonDelegate:CustomButtonDelegate? = nil
    
    //UserInfo
    private lazy var name:UILabel = { .init() }()
    
    private lazy var userName:UILabel = { .init() }()
	
	private lazy var transactionTypeLabel:UILabel = { .init() }()
	
	private lazy var transactionTimeLabel:UILabel = { .init() }()
    
	private lazy var userInfoView:UIStackView = {
		.VStack(views:[name,userName],spacing: 5, aligmment: .leading)
	}()
	
	private lazy var transactionLabel:UIStackView = {
		.VStack(views:[transactionTypeLabel,.spacer(),transactionTimeLabel],spacing: 5, aligmment: .trailing)
	}()
    
    //MainStackView
    private lazy var stack:UIStackView = {
		let stack: UIStackView = .HStack(spacing: 10, aligmment: .center)
		[imageView,userInfoView,transactionLabel].forEach(stack.addArrangedSubview)
		return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        transactionTypeLabel.textAlignment = .right
        transactionTimeLabel.textAlignment = .right

        self.addSubview(stack)
		imageView.setFrameConstraints(width: 40, height: 40)
		setContraintsToChild(stack, edgeInsets: .zero)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
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
		UIImage.loadImage(url: validOffer.image ?? "", for: imageView, at: \.image)
		(validOffer.name ?? "XXX").replace().styled(font: .medium, color: .appBlackColor, size: 14).renderInto(target: name)
		"@\(validOffer.nft?.metadata?.compiler ?? "X")".styled(font: .medium, color: .appGrayColor, size: 12).renderInto(target: userName)
		"Sale".styled(font: .medium, color: .appGreenColor, size: 14).renderInto(target: transactionTypeLabel)
		"2 minutes ago".styled(font: .medium, color: .appGrayColor, size: 12).renderInto(target: transactionTimeLabel)
	}
	
	internal override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = .solid(color: .appGrayColor, frame: .squared(40))
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

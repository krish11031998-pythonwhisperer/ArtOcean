//
//  NFTOfferTableViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

class NFTOfferTableViewCell:ConfigurableCell{
    
    private var offer:NFTArtOffer = .init()
    
    public static var identifier = "NFTOfferCell"
    
    private lazy var initialLabel:UILabel = {
        let label = self.labelBuilder(text: "", size: 14, weight: .bold, color: .white, numOfLines: 1)
        label.backgroundColor = .appGrayColor
        label.textAlignment = .center
        label.clipsToBounds = true
		label.setFrameConstraints(width: 40, height: 40)
        label.layer.cornerRadius = 20
        return label
    }()
	
    private lazy var nameLabel = self.labelBuilder(text: "", size: 14, weight: .bold, color: .black, numOfLines: 1)
    
    private lazy var expirationLabel = self.labelBuilder(text: "", size: 12, weight: .regular, color: .black, numOfLines: 1)
    
    private lazy var offerNameAndExpirationStack:UIView = {
		return .StackBuilder(views: [nameLabel,expirationLabel], spacing: 12, axis: .vertical)
    }()
    
    private lazy var priceLabel:UILabel = {
       let label = self.labelBuilder(text: "", size: 14, weight: .bold, color: .black, numOfLines: 1)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var percentLabel:UILabel = {
        let label = self.labelBuilder(text: "", size: 12, weight: .regular, color: .black, numOfLines: 1)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var offerPriceAndPercentnStack:UIView = {
		return .StackBuilder(views: [priceLabel,percentLabel], axis: .vertical)
    }()
    
    private lazy var cellStack:UIStackView = {
		let stack: UIStackView = .init(arrangedSubviews: [offerNameAndExpirationStack,.spacer(),offerPriceAndPercentnStack])
        return stack
    }()
    
    //MARK: - UITableViewCell Handlers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectedBackgroundView = UIView.clearView()
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected{
            self.bouncyButtonClick()
        }
    }
    
    func setupViews(){
		let stack = UIStackView(arrangedSubviews: [initialLabel,cellStack])
		stack.spacing = 12
		stack.alignment = .center
		contentView.addSubview(stack)
		contentView.setConstraintsToChild(stack, edgeInsets: .init(vertical: 10, horizontal: 15))
	}
	
	func configureCell(with model: NFTArtOffer) {
		if subviews.isEmpty{
			subviews.forEach { $0.removeFromSuperview() }
		}
		updateCell(offer: model)
	}
    
}

//MARK: -  DateHandler
extension NFTOfferTableViewCell{
    
	public func updateCell(offer:NFTArtOffer){
		backgroundColor = .clear
		selectionStyle = .none
		expirationLabel.text = "Expiration in \(offer.time ?? 0) days"
		nameLabel.text = offer.name ?? "No Name"
		priceLabel.text = "\(offer.price ?? 0)"
		percentLabel.text = offer.percent ?? "0"
		initialLabel.text = (offer.name ?? "No Name").split(separator: " ").compactMap({$0.first}).reduce("", {$0.isEmpty ? String($1) : $0 + String($1)})
	}
}

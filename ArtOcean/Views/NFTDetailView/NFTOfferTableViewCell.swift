//
//  NFTOfferTableViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

class NFTOfferTableViewCell:UITableViewCell{
    
    private var offer:NFTArtOffer = .init()
    
    public static var identifier = "NFTOfferCell"
    
    private lazy var initialLabel:UILabel = {
        let label = self.labelBuilder(text: "", size: 14, weight: .bold, color: .black, numOfLines: 1)
        label.backgroundColor = .appWhiteBackgroundColor
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 20
        return label
    }()
    
    private lazy var nameLabel = self.labelBuilder(text: "", size: 14, weight: .bold, color: .black, numOfLines: 1)
    
    private lazy var expirationLabel = self.labelBuilder(text: "", size: 12, weight: .regular, color: .black, numOfLines: 1)
    
    private lazy var offerNameAndExpirationStack:UIStackView = {
        return UIView.StackBuilder(views: [nameLabel,expirationLabel], ratios: [0.5,0.5], spacing: 4, axis: .vertical)
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
    
    private lazy var offerPriceAndPercentnStack:UIStackView = {
        return UIView.StackBuilder(views: [priceLabel,percentLabel], ratios: [0.5,0.5], spacing: 4, axis: .vertical)
    }()
    
    private lazy var cellStack:UIStackView = {
        let stack = UIView.StackBuilder(views: [offerNameAndExpirationStack,offerPriceAndPercentnStack], ratios: [0.5,0.5], spacing: 4, axis: .horizontal)
        return stack
    }()
    
    //MARK: - UITableViewCell Handlers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectedBackgroundView = UIView.clearView()
        self.backgroundColor = .white
        self.setupViews()
        self.setupLayout()
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
        self.addSubview(self.initialLabel)
        self.addSubview(self.cellStack)
    }
    
    func setupLayout(){
        
        self.initialLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.initialLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.initialLabel.layer.cornerRadius = 20
        self.initialLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.initialLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.cellStack.leadingAnchor.constraint(equalTo: self.initialLabel.trailingAnchor,constant: 12).isActive = true
        self.cellStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.cellStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.cellStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
}

//MARK: -  DateHandler
extension NFTOfferTableViewCell{
    
    public func updateCell(offer:NFTArtOffer){
        DispatchQueue.main.async {
            self.expirationLabel.text = "Expiration in \(offer.time ?? 0) days"
            self.nameLabel.text = offer.name ?? "No Name"
            self.priceLabel.text = "\(offer.price ?? 0)"
            self.percentLabel.text = offer.percent ?? "0"
            self.initialLabel.text = (offer.name ?? "No Name").split(separator: " ").compactMap({$0.first}).reduce("", {$0.isEmpty ? String($1) : $0 + String($1)})
        }
    }
}

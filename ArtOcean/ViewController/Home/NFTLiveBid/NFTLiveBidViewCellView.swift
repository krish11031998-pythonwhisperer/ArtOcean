//
//  NFTLiveBidViewCellView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 15/06/2022.
//

import Foundation
import UIKit

class NFTLiveBidCellView:UIView{
    
    private var nftInfo:NFTModel? = nil
    var largeCard:Bool = false
    private lazy var imageView:CustomImageView = CustomImageView(cornerRadius: 16, maskedCorners: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
  
    private lazy var title:UILabel = {
        let label = self.labelBuilder(text: "", size: 14, weight: .bold, color: .appBlackColor, numOfLines: 1)
        return label
    }()
    
    private lazy var owner = self.labelBuilder(text: "", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1)
    
    private lazy var price = self.labelBuilder(text: "3 ETH", size: 12, weight: .medium, color: .appGreenColor, numOfLines: 1)

    private let shareButton:CustomButton = CustomButton(name: "share", handler: nil, autolayout: true)
    
    private let loveButton:CustomButton = CustomButton(name: "heart", handler: nil, autolayout: true)
    
    private lazy var artPriceAndTitleStack:UIStackView = {
        let view:UIStackView = UIStackView()
        view.axis = .horizontal
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .top
        view.addArrangedSubview(self.title)
        view.addArrangedSubview(self.price)
        
        title.setContentHuggingPriority(.init(249), for: .horizontal)
        title.setContentCompressionResistancePriority(.init(749), for: .horizontal)

        
        self.price.textAlignment = .right

        return view
    }()
    
    private lazy var timeLeftLabel:UILabel = {
        var label = CustomLabel(text: "3h 12m 36s left", size: 12, weight: .medium, color: .appBlueColor, numOfLines: 1)
        label.layer.cornerRadius = 14.5
        label.backgroundColor = .appBlueColor.withAlphaComponent(0.15)
        label.clipsToBounds = true
        label.textAlignment = .center
        label.frame = label.frame.inset(by: .init(top: 5, left: 7.5, bottom: 5, right: 7.5))
        return label
    }()

    private lazy var bidButton:CustomLabelButton = {
        var button = CustomLabelButton(title: "Place a bid", color: .white, backgroundColor: .init(hexString: "2281E3",alpha: 1))
        button.layer.cornerRadius = 14.5
        button.delegate = self
        return button
    }()
    
    private lazy var biddingStack:UIStackView = {
        let view:UIStackView = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let clearSpacerView:UIView = .clearView()
        view.addArrangedSubview(self.timeLeftLabel)
        view.addArrangedSubview(self.bidButton)
        
        NSLayoutConstraint.activate([
//            self.timeLeftLabel.widthAnchor.constraint(equalToConstant: 109),
            self.bidButton.widthAnchor.constraint(equalTo: timeLeftLabel.widthAnchor)
        ])
        
        return view
        
    }()
    
    private lazy var NFTInfo:UIStackView = {
        
        let view:UIStackView = .init()
        
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 20
        view.addArrangedSubview(self.owner)
        view.addArrangedSubview(self.artPriceAndTitleStack)
        view.addArrangedSubview(self.biddingStack)

        view.setCustomSpacing(4, after: owner)
        
        artPriceAndTitleStack.setContentHuggingPriority(.init(249), for: .vertical)
        artPriceAndTitleStack.setContentHuggingPriority(.init(749), for: .vertical)
        
        NSLayoutConstraint.activate([
            self.biddingStack.heightAnchor.constraint(equalToConstant: 29),
        ])
        
        return view
        
    }()
    
    private lazy var card:UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 5
        
        view.addArrangedSubview(self.imageView)
        view.addArrangedSubview(self.NFTInfo)
        
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6,constant: -5),
            self.NFTInfo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
        
        return view
    }()
    
    
    init(nft:NFTModel? = nil,largeCard:Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
        self.addSubview(self.NFTInfo)
        self.addSubview(self.loveButton)
        self.addSubview(self.shareButton)
        
        if largeCard{
            self.largeCard = largeCard
            title.font = .init(name: title.font.fontName, size: 18)
            price.font = .init(name: price.font.fontName, size: 14)
        }
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
 
        if let safeNFT = nft{
            self.updateUIWithNFT(safeNFT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    
	override func layoutSubviews() {
		super.layoutSubviews()
		self.setupLayout()
		if frame.height > 245{
			self.largeCard = true
			title.font = .init(name: title.font.fontName, size: 18)
			price.font = .init(name: price.font.fontName, size: 14)
		}
	}
    
    public func updateUIWithNFT(_ nft:NFTModel,idx:Int? = nil,largeCard:Bool = false){

        self.nftInfo = nft
        
        if let safeTitle = nft.title{
            DispatchQueue.main.async { [weak self] in
                self?.title.text = safeTitle == "" ? "Title" : safeTitle
                self?.owner.text = "Owner"
            }
        }
        
        self.imageView.updateImageView(url: nft.metadata?.image)
        
        if largeCard{
            title.font = .init(name: title.font.fontName, size: 18)
        }
    }
    
    func setupLayout(){

        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.57).isActive = true
        
//        self.NFTInfo.widthAnchor.constraint(equalTo:self.widthAnchor,constant: -16).isActive = true
        self.NFTInfo.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: largeCard ? 2 : 1.5).isActive = true
        trailingAnchor.constraint(equalToSystemSpacingAfter: NFTInfo.trailingAnchor, multiplier: largeCard ? 2 : 1.5).isActive = true
        self.NFTInfo.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10).isActive = true
        self.NFTInfo.topAnchor.constraint(equalTo: self.imageView.bottomAnchor,constant: 16).isActive = true
        
        //Lovebutton
        self.loveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -12).isActive = true
        self.loveButton.centerYAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true


        //ShareButton
        self.shareButton.trailingAnchor.constraint(equalTo: self.loveButton.leadingAnchor,constant: -8).isActive = true
        self.shareButton.centerYAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
    }
    
	public func prepareToReuse(){
		imageView.image = nil
	}
}



//MARK: - CustomButtonDelegate
extension NFTLiveBidCellView:CustomButtonDelegate{
    func handleTap() {
        print("(DEBUG) Clicked on the Cell!")
    }
}

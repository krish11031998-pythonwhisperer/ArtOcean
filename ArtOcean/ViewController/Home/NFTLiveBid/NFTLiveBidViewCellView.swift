//
//  NFTLiveBidViewCellView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 15/06/2022.
//

import Foundation
import UIKit

class NFTLiveBidView : UIView {
    
    private var nftInfo:NFTModel? = nil
    var largeCard:Bool = false
    private lazy var imageView:CustomImageView = CustomImageView(cornerRadius: 16, maskedCorners: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
  
    private lazy var title:UILabel = {
        let label = self.labelBuilder(text: "", size: 14, weight: .bold, color: .textColor, numOfLines: 1)
        return label
    }()
    
    private lazy var owner = self.labelBuilder(text: "", size: 12, weight: .medium, color: .subtitleColor, numOfLines: 1)
    
    private lazy var price = self.labelBuilder(text: "3 ETH", size: 12, weight: .medium, color: .appGreenColor, numOfLines: 1)

	private let shareButton:CustomImageButton = {
		let button: CustomImageButton = .init(name: .share,addBG:true) {
			print("(DEBUG) share pressed")
		}
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private let loveButton:CustomImageButton = {
		let button: CustomImageButton = .init(name: .heartOutline,addBG:true) {
			print("(DEBUG) heart pressed")
		}
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
    
    private lazy var artPriceAndTitleStack:UIStackView = {
		let view:UIStackView = UIStackView(arrangedSubviews: [title,.spacer(),price])
        view.axis = .horizontal
        view.spacing = 5
        view.alignment = .top
		price.textAlignment = .right
        return view
    }()
    
    private lazy var timeLeftLabel:UIView = {
        var label = CustomLabel(text: "3h 12m 36s left", size: 12, weight: .medium, color: .appBlueColor, numOfLines: 1)
        label.textAlignment = .center
		return label.labelCapsule(color: .appBlueColor.withAlphaComponent(0.15), cornerRadius: 14.5)
    }()

    private lazy var bidButton:UIView = {
		var button = CustomLabelButton(title: "Place a bid",font: .medium, size: 12, color: .white, backgroundColor: .init(hexString: "2281E3",alpha: 1))
        button.delegate = self
		return button
    }()
    
    private lazy var biddingStack:UIStackView = {
		let view:UIStackView = UIStackView(arrangedSubviews: [timeLeftLabel,.spacer(),bidButton])
        view.axis = .horizontal
        view.spacing = 8
        return view
        
    }()
    
    private lazy var NFTInfo : UIView = {
		let view = UIView()
		let stack:UIStackView = .init(arrangedSubviews: [owner,artPriceAndTitleStack,biddingStack])
        stack.axis = .vertical
        stack.spacing = 4
        stack.setCustomSpacing(12, after: artPriceAndTitleStack)
		
		view.addSubview(stack)
		view.setConstraintsToChild(stack, edgeInsets: .init(vertical: 10, horizontal: 12),withPriority: 750)
		
		view.addSubview(loveButton)
		view.addSubview(shareButton)
		
		NSLayoutConstraint.activate([
			view.trailingAnchor.constraint(equalToSystemSpacingAfter: loveButton.trailingAnchor, multiplier: 1.5),
			loveButton.centerYAnchor.constraint(equalTo: view.topAnchor),
			loveButton.leadingAnchor.constraint(equalToSystemSpacingAfter: shareButton.trailingAnchor, multiplier: 1.5),
			shareButton.centerYAnchor.constraint(equalTo: view.topAnchor)
		])
		
		biddingStack.heightAnchor.constraint(equalToConstant: 29).isActive = true
        return view
    }()
    
	
	private func buildCard() {
		removeAllSubViews()
		
		let view = UIStackView(arrangedSubviews: [imageView,NFTInfo])
		view.axis = .vertical
		view.spacing = 5
		imageView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -117).isActive = true
		view.backgroundColor = interface == .light ? .surfaceBackground : .appIndigo
		view.cornerRadius = 16
		
		loveButton.buttonBackgroundColor = .surfaceBackground
		shareButton.buttonBackgroundColor = .surfaceBackground
		
		addViewAndSetConstraints(view, edgeInsets: .zero)
	}
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		buildCard()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if frame.height > 245{
			self.largeCard = true
			title.font = .init(name: title.font.fontName, size: 18)
			price.font = .init(name: price.font.fontName, size: 14)
		}
	}
    
    public func updateUIWithNFT(_ nft:NFTModel){
        nftInfo = nft
        if let safeTitle = nft.title{
            DispatchQueue.main.async { [weak self] in
                self?.title.text = safeTitle == "" ? "Title" : safeTitle
                self?.owner.text = "Owner"
            }
        }
        
        imageView.updateImageView(url: nft.metadata?.image)
        
        if largeCard{
            title.font = .init(name: title.font.fontName, size: 18)
        }
    }
       
	public func prepareForReuse() {
		imageView.image = .loadingBackgroundImage
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		buildCard()
	}
}

//MARK: - ConfigurableStyling

extension NFTLiveBidView: ConfigurableStyling {
	
	func configureView(with model: NFTArtCollectionViewCellData) {
		backgroundColor = .appWhiteBackgroundColor
		self.updateUIWithNFT(model.nft)
	}
	
	static var insetPadding: UIEdgeInsets {
		.init(vertical: 12, horizontal: 24)
	}
	
	static var cornerRadius: CGFloat { 16 }
	
	func prepareCellForReuse() {
		imageView.image = nil
	}
}

//MARK: - CustomButtonDelegate
extension NFTLiveBidView:CustomButtonDelegate{
    func handleTap() {
        print("(DEBUG) Clicked on the Cell!")
    }
}

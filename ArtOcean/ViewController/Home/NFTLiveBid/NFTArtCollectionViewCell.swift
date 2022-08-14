//
//  NFTArtCollectionViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 31/05/2022.
//

import Foundation
import UIKit

struct NFTArtCollectionViewCellData:ActionProvider {
	var nft:NFTModel
	var action: Callback?
}

extension NFTArtCollectionViewCellData {
	
	static func decodedFromItem(item: Item) -> Self? {
		switch item {
		case .artData(let nFTModel):
			return .init(nft: nFTModel)
		default:
			return nil
		}
	}
	
}

class NFTArtCollectionViewCell:UICollectionViewCell{
    
    private var nft:NFTModel? = nil
    
    public static let identifier = "NFTArtCollectionViewCell"
    
    private lazy var imageView:CustomImageView = {
        let imgView = CustomImageView(cornerRadius: 16,maskedCorners: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
        return imgView
    }()
    
    public var delegate:NFTArtCellDelegate? = nil
    
	private lazy var artTitle:UILabel = { .init() }()
    
    private lazy var priceView:CustomLabelButton = {
		return .init(title: "", image: .init(named: "eth"),color: .appBlackColor)
    }()
    
	private lazy var likeView:CustomLabelButton = {
		return .init(title: "", image: .init(named: "heart"),color: .appBlackColor)
    }()
    
	private lazy var infoView: UIStackView = {
		let stack = StackContainer(innerView: [artTitle,infoDetails])
		stack.spacing = 4
		stack.backgroundColor = .white
		stack.layer.cornerRadius = 16
		stack.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
		
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = .init(top: 12, left: 8, bottom: 16, right: 8)
		
		stack.heightAnchor.constraint(equalToConstant: 76).isActive = true
		
		return stack
	}()
	
	private lazy var infoDetails: UIStackView = {
		let stackView: UIStackView = .init(arrangedSubviews: [priceView,.spacer(),likeView])
		return stackView
	}()
	
	private func setupView() {
		let stack: UIStackView = .init(arrangedSubviews: [imageView,infoView])
		stack.axis = .vertical
		addViewAndSetConstraints(stack, edgeInsets: .zero)
		backgroundColor = .white
		layer.cornerRadius = 16
		addShadow()
	}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		setupView()
//        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTap(){
        self.bouncyButtonClick {
            if let safeNFT = self.nft{
                self.delegate?.viewArt(art: safeNFT)
            }
        }
    }
    
    func resetCell(){
        self.artTitle.text = ""
		self.imageView.image = .solid(color: .appGrayColor)
    }
    
    public func updateUIWithNFT(_ nft:NFTModel,idx:Int? = nil){
        self.resetCell()
        self.nft = nft
        //Simulating PriceLabel Change
		nft.title?.replace().styled(font: .bold, color: .appBlackColor, size: 14).renderInto(target: artTitle)
		priceView.updateUI(title: "0.47".styled(font: .medium, color: .appBlackColor, size: 12), image: nil)
		likeView.updateUI(title: "30".styled(font: .medium, color: .appBlackColor, size: 12), image: nil)
		UIImage.loadImage(url: nft.metadata?.image, for: imageView, at: \.image)
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		print("(DEBUG) Reusing the cell!")
		resetCell()
	}
    
}

//MARK: - Configurable Cell
extension NFTArtCollectionViewCell:ConfirgurableCell{
    func configure(_ data: Item) {
        switch data{
        case .artData(let nftModel):
            self.updateUIWithNFT(nftModel)
        default:
            print("(DEBUG) Data in incorrect format is provided!")
        }
    }
    
}

//MARK: -
extension NFTArtCollectionViewCell: Configurable {
	func configureCell(with model: NFTArtCollectionViewCellData) {
		updateUIWithNFT(model.nft)
	}
	
	static var itemSize: CGSize {
		.init(width: 154, height: 176)
	}
}

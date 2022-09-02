//
//  NFTArtCollectionViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 31/05/2022.
//

import Foundation
import UIKit

struct NFTArtCollectionViewCellData: ActionProvider {
	var nft:NFTModel
	var action: Callback?
}

extension NFTArtCollectionViewCellData {
	
	static func decodedFromItem(item: Item) -> Self? {
		switch item {
		case .artData(let nFTModel):
			return .init(nft: nFTModel) {
				NFTStorage.selectedArt  = nFTModel
				NotificationCenter.default.post(name: .showArt, object: nil)
			}
		default:
			return nil
		}
	}
	
}

class NFTArtCollectionViewCell:UICollectionViewCell{
    
    private var nft:NFTModel? = nil
    
    public static let identifier = "NFTArtCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView()
		imgView.clipsToBounds = true
		imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    public var delegate:NFTArtCellDelegate? = nil
    
	private lazy var artTitle:UILabel = {
		let label : UILabel = .init()
		"XXX".styled(font: .bold, color: .textColor, size: 14).renderInto(target: label)
		return label
	}()
    
    private lazy var priceView:CustomLabelButton = {
		let imgSize: CGSize = .init(width: 6, height: 10)
		return .init(title: "", image: .init(named: "eth")?.resized(imgSize),imageSize: imgSize, color: .textColor)
    }()
    
	private lazy var likeView:CustomLabelButton = {
		return .init(title: "", image: .init(named: "heart")?.resized(.squared(10)), color: .textColor)
    }()
    
	private lazy var infoView: UIView = {
		let stack: UIStackView = .VStack(views: [artTitle, infoDetails], spacing: 4, aligmment: .leading)
		
		stack.distribution = .fill
		stack.compressVerticalFit()
		let result = stack.embedInView(edges: .init(top: 12, left: 8, bottom: 16, right: 8))
		return result
	}()
	
	private lazy var infoDetails: UIStackView = {
		let stackView: UIStackView = .init(arrangedSubviews: [priceView,.spacer(),likeView])
		return stackView
	}()
	
	private func setupView() {
		let stack: UIStackView = .VStack(views: [imageView, infoView], spacing: 0, aligmment: .fill)
		stack.clipsToBounds = true
		stack.cornerRadius(16, at: .all)
		addViewAndSetConstraints(stack, edgeInsets: .zero)
		stack.backgroundColor = interface == .light ? .surfaceBackground : .appIndigo
		cornerRadius(16, at: .all)
		
		if !isDark { addShadow() }
		
	}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		setupView()
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
		DispatchQueue.main.async {
			self.imageView.image = .loadingBackgroundImage
		}
    }
    
    public func updateUIWithNFT(_ nft:NFTModel,idx:Int? = nil){
        self.resetCell()
        self.nft = nft
        //Simulating PriceLabel Change
		nft.title?.replace().styled(font: .bold, color: .textColor, size: 14).renderInto(target: artTitle)
		priceView.updateUI(title: "0.47".styled(font: .medium, color: .textColor, size: 12), image: nil)
		likeView.updateUI(title: "30".styled(font: .medium, color: .textColor, size: 12), image: nil)
		UIImage.loadImage(url: nft.metadata?.image, for: imageView, at: \.image)
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		print("(DEBUG) Reusing the cell!")
		resetCell()
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		removeAllSubViews()
		setupView()
	}
    
}

//MARK: - Configurable Cell
extension NFTArtCollectionViewCell:ConfirgurableCell{
    func configure(_ data: Item) {
		guard let nftModel = data.nftArtData else { return }
		updateUIWithNFT(nftModel)
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

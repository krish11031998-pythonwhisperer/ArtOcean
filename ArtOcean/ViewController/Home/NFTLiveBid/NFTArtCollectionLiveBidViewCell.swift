//
//  NFTTypeCollectionViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class NFTArtCollectionLiveBidViewCell: UICollectionViewCell {
    
    public static var identifier:String = "NFTCard"
    private var nftInfo:NFTModel? = nil
    public var delegate:NFTArtCellDelegate? = nil
 
    @objc func onTapHandler(_ recognizer:UITapGestureRecognizer){
        self.bouncyButtonClick {
            if let safeNFTData = self.nftInfo{
                self.delegate?.viewArt(art: safeNFTData)
            }
        }
    }
    
    private let nftContentViewCell:NFTLiveBidView = NFTLiveBidView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		addViewAndSetConstraints(nftContentViewCell, edgeInsets: .zero)
		backgroundColor = interface == .light ? .surfaceBackground : .appIndigo
		cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func updateUIWithNFT(_ nft:NFTModel,idx:Int? = nil){
        self.nftInfo = nft
        nftContentViewCell.updateUIWithNFT(nft)
    }
    

	override func prepareForReuse() {
		super.prepareForReuse()
		nftContentViewCell.prepareForReuse()
	}
    
}

//MARK: - Configurable
extension NFTArtCollectionLiveBidViewCell: Configurable {
	func configureCell(with model: NFTArtCollectionViewCellData) {
		updateUIWithNFT(model.nft)
	}
	
	static var itemSize: CGSize {
		.init(width: 225, height: 245)
	}
}

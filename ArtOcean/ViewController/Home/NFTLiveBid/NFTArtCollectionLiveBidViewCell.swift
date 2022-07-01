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
    
    private let nftContentViewCell:NFTLiveBidCellView = NFTLiveBidCellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.nftContentViewCell)
        
        self.addShadow()
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapHandler(_:))))
        
        self.addShadow()
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func updateUIWithNFT(_ nft:NFTModel,idx:Int? = nil){
        self.nftInfo = nft
        nftContentViewCell.updateUIWithNFT(nft)
    }
    
    func setupLayout(){

        self.nftContentViewCell.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nftContentViewCell.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nftContentViewCell.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nftContentViewCell.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		nftContentViewCell.prepareToReuse()
	}
    
}


//MARK: - CustomButtonDelegate
extension NFTArtCollectionLiveBidViewCell:CustomButtonDelegate{
    func handleTap() {
        print("(DEBUG) Clicked on the Cell!")
    }
}

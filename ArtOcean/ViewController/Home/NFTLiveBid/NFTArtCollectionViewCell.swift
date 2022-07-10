//
//  NFTArtCollectionViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 31/05/2022.
//

import Foundation
import UIKit

class NFTArtCollectionViewCell:UICollectionViewCell{
    
    private var nft:NFTModel? = nil
    
    public static let identifier = "NFTArtCollectionViewCell"
    
    private lazy var imageView:CustomImageView = {
        let imgView = CustomImageView(cornerRadius: 16,maskedCorners: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
        return imgView
    }()
    
    public var delegate:NFTArtCellDelegate? = nil
    
    private lazy var artTitle:UILabel = self.labelBuilder(text: "", size: 14, weight: .bold, color: .appBlackColor, numOfLines: 1)
   
    private lazy var priceLabel:UILabel = CustomLabel(text: "0.47 ETH", size: 12, weight: .medium, color: .black, numOfLines: 1)
    
    private lazy var priceView:UIView = {
		let img:CustomImageView = .init(named: "eth", cornerRadius: 0)
		img.contentMode = .scaleAspectFit
		img.setFrameConstraints(width: 10, height: 20)
		let view = UIStackView(arrangedSubviews: [img,priceLabel])
		view.spacing = 4
        
        return view
    }()
    
    
    private let likeLabel:UILabel = CustomLabel(text: "30", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1,adjustFontSize: true)
    
	private lazy var likeView:UIView = {
		let img:CustomImageView = .init(named: "heart", cornerRadius: 0)
		img.contentMode = .scaleAspectFit
		img.setFrameConstraints(width: 10, height: 20)
        let view = UIStackView(arrangedSubviews: [img,likeLabel])
		view.spacing = 4
        return view
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
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
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
        self.priceLabel.text = ""
        self.likeLabel.text = ""
        self.imageView.image = .init(named: "placeHolder")
    }
    
    public func updateUIWithNFT(_ nft:NFTModel,idx:Int? = nil){
        self.resetCell()
        self.nft = nft
		if let safeTitle = nft.title{
			self.artTitle.text = safeTitle == "" ? "Title" : safeTitle
		}
        
        //Simulating PriceLabel Change
        self.priceLabel.text = "0.47"
        self.likeLabel.text = "30"

        self.imageView.updateImageView(url: nft.metadata?.image)
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

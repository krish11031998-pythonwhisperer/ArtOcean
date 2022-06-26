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
        let currencyImg = UIImageView()
        currencyImg.translatesAutoresizingMaskIntoConstraints = false
        if let img = UIImage(named: "eth"){
            currencyImg.image = img
        }
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceLabel)
        view.addSubview(currencyImg)
        
        NSLayoutConstraint.activate([
            currencyImg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currencyImg.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            currencyImg.widthAnchor.constraint(equalToConstant: 10),
            currencyImg.heightAnchor.constraint(equalToConstant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: currencyImg.trailingAnchor,constant: 4),
            priceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    
    private let likeLabel:UILabel = CustomLabel(text: "30", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1,adjustFontSize: true)
    
    private lazy var likeView:UIView = {
        
        let heartImg = UIImageView()
        heartImg.translatesAutoresizingMaskIntoConstraints = false
        if let img = UIImage(named: "heart"){
            heartImg.image = img
        }
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(likeLabel)
        view.addSubview(heartImg)
        
        NSLayoutConstraint.activate([
            heartImg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heartImg.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            heartImg.widthAnchor.constraint(equalToConstant: 10),
            heartImg.heightAnchor.constraint(equalToConstant: 10),
            likeLabel.leadingAnchor.constraint(equalTo: heartImg.trailingAnchor,constant: 4),
            likeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
	func setupInfoView(){
		let stack = StackContainer(innerView: [artTitle,infoDetails])
		stack.spacing = 4
		stack.backgroundColor = .white
		addSubview(stack)
		stack.layer.cornerRadius = 16
		stack.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
		
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = .init(top: 12, left: 8, bottom: 16, right: 8)
		
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.heightAnchor.constraint(equalToConstant: 76).isActive = true
		stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
	
    private lazy var infoDetails = UIView.StackBuilder(views: [self.priceView,self.likeView], ratios: [0.75,0.25], spacing: 5, axis: .horizontal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
//        self.addSubview(self.artTitle)
//        self.addSubview(self.stackView)
		setupInfoView()
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        
        self.addShadow()
		self.setupLayout()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
	
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
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
            DispatchQueue.main.async { [weak self] in
                self?.artTitle.text = safeTitle == "" ? "Title" : safeTitle
            }
        }
        
        //Simulating PriceLabel Change
        self.priceLabel.text = "0.47"
        self.likeLabel.text = "30"

        
        self.imageView.updateImageView(url: nft.metadata?.image)
    }
    
    func setupLayout(){
        
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -76).isActive = true
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

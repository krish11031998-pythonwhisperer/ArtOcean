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
    
    private lazy var priceView:UIView = {
        let priceLabel = self.labelBuilder(text: "0.47 ETH", size: 12, weight: .medium, color: .black, numOfLines: 1)
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
    
    
    private lazy var likeView:UIView = {
        let likeLabel = self.labelBuilder(text: "30", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1,adjustFontSize: true)
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
    
    private lazy var stackView = UIView.StackBuilder(views: [self.priceView,self.likeView], ratios: [0.65,0.35], spacing: 5, axis: .horizontal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
        self.addSubview(self.artTitle)
        self.addSubview(self.stackView)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        
        self.addShadow()
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        
        self.setupLayout()
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
    
    public func updateUIWithNFT(_ nft:NFTModel,idx:Int? = nil){
        self.nft = nft
        if let safeTitle = nft.title{
            DispatchQueue.main.async { [weak self] in
                self?.artTitle.text = safeTitle == "" ? "Title" : safeTitle
            }
        }
        
        self.imageView.updateImageView(url: nft.metadata?.image)
    }
    
    func setupLayout(){
        
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.57).isActive = true
        
        self.artTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 12).isActive = true
        self.artTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -12).isActive = true
        self.artTitle.topAnchor.constraint(equalTo: self.imageView.bottomAnchor,constant: 12).isActive = true
        
        self.stackView.leadingAnchor.constraint(equalTo: self.artTitle.leadingAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -16).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.artTitle.bottomAnchor,constant: 4).isActive = true
        self.stackView.widthAnchor.constraint(equalTo:self.widthAnchor,constant: -20).isActive = true
    }
    
}

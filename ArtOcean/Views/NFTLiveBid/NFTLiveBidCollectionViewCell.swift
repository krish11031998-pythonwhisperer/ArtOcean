//
//  NFTTypeCollectionViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class NFTLiveBidCollectionViewCell: UICollectionViewCell {
    
    public static var identifier:String = "NFTCard"
    
    private lazy var imageView:UIImageView = {
        let imageView = self.imageView(cornerRadius: 16, autoLayout: false)
        imageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        return imageView
    }()
    
    private lazy var title:UILabel = {
        let label = self.labelBuilder(text: "", size: 14, weight: .bold, color: .appBlackColor, numOfLines: 1)
        return label
    }()
    
    private lazy var owner = self.labelBuilder(text: "", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1)
    
    private lazy var price = self.labelBuilder(text: "3 ETH", size: 12, weight: .medium, color: .appGreenColor, numOfLines: 1)
    
    private lazy var artPriceAndTitleStack:UIView = {
        let view:UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.title)
        view.addSubview(self.price)
        
        self.price.textAlignment = .right
        
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: view.topAnchor,constant: 5),
            self.title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.title.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6,constant: -5),
            self.title.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -5),
            
            self.price.topAnchor.constraint(equalTo: view.topAnchor,constant: 5),
            self.price.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.price.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            self.price.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -5),
        ])
        return view
    }()
    
    private lazy var timeLeftLabel:UILabel = {
        var label = self.labelBuilder(text: "3h 12m 36s left", size: 12, weight: .medium, color: .appBlueColor, numOfLines: 1)
        label.layer.cornerRadius = 15
        label.backgroundColor = .appBlueColor.withAlphaComponent(0.15)
        label.clipsToBounds = true
        label.textAlignment = .center
        label.bounds = label.frame.inset(by: .init(top: 5, left: 7.5, bottom: 5, right: 7.5))
        return label
    }()
    
    
    private lazy var bidButton:UILabel = {
        var label = self.labelBuilder(text: "Place a bid", size: 12, weight: .medium, color: .white, numOfLines: 1)
        label.backgroundColor = .init(hexString: "2281E3",alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var biddingStack:UIView = {
        let view:UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.timeLeftLabel)
        view.addSubview(self.bidButton)
        
        NSLayoutConstraint.activate([
            self.timeLeftLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 5),
            self.timeLeftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.timeLeftLabel.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.5,constant: -4),
            self.timeLeftLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -5),
            
            self.bidButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 5),
            self.bidButton.leadingAnchor.constraint(equalTo: self.timeLeftLabel.trailingAnchor,constant: 8),
            self.bidButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.5,constant: -4),
            self.bidButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -5)
        ])
        
        return view
        
    }()
    
    private lazy var NFTInfo:UIView = {
        
        let view:UIView = .init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.owner)
        view.addSubview(self.artPriceAndTitleStack)
        view.addSubview(self.biddingStack)
        
        NSLayoutConstraint.activate([
            self.owner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.owner.topAnchor.constraint(equalTo: view.topAnchor),
            self.owner.widthAnchor.constraint(equalTo:view.widthAnchor),
            self.owner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            self.artPriceAndTitleStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.artPriceAndTitleStack.topAnchor.constraint(equalTo: owner.bottomAnchor),
            self.artPriceAndTitleStack.widthAnchor.constraint(equalTo:view.widthAnchor),
            self.artPriceAndTitleStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            self.biddingStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.biddingStack.topAnchor.constraint(equalTo: self.artPriceAndTitleStack.bottomAnchor),
            self.biddingStack.widthAnchor.constraint(equalTo:view.widthAnchor),
            self.biddingStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
        
        ])
        
        return view
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.NFTInfo)
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.addShadow()
    }
    
    
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    
    public func updateUIWithNFT(_ nft:NFTModel,idx:Int? = nil){

        if let safeTitle = nft.title{
            DispatchQueue.main.async { [weak self] in
                self?.title.text = safeTitle == "" ? "Title" : safeTitle
                self?.owner.text = "Owner"
            }
        }
        
        if let safeImg = nft.metadata?.image{
            ImageDownloader.shared.fetchImage(urlStr: safeImg) { [weak self] result in
                switch result{
                    case .success(let image):
                        if let safeImageView = self?.imageView{
                            DispatchQueue.main.async {
                                UIView.transition(with: safeImageView,duration: 1.0, options: [.curveEaseOut, .transitionCrossDissolve]) {
                                    safeImageView.image = image
                                }
                            }
                        }
                    case .failure(let err):
                        print("(Error) err : ",err.localizedDescription)
                }
            }
        }
    }
    
    func setupLayout(){
        
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6,constant: -20).isActive = true
        
        self.NFTInfo.widthAnchor.constraint(equalTo:self.widthAnchor,constant: -16).isActive = true
        self.NFTInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:8).isActive = true
        self.NFTInfo.heightAnchor.constraint(equalTo: self.heightAnchor,multiplier: 0.4).isActive = true
        self.NFTInfo.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10).isActive = true
        self.NFTInfo.topAnchor.constraint(equalTo: self.imageView.bottomAnchor,constant: 10).isActive = true
    }
    
    
}

extension NFTLiveBidCollectionViewCell{
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = .init(named: "placeHolder")
//        self.title.text = ""
//        self.owner.text = ""
    }
}

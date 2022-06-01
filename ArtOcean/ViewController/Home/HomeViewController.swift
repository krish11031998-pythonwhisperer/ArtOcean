//
//  HomeViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var textLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "Welcome, Krishna"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var liveBidCollection:NFTArtCollection = {
        let collection = NFTArtCollection(orientation: .horizontal)
        collection.collectionDelegate = self
        return collection
    }()

    private lazy var liveBidCollectionContainer:Container = {
        let container = Container(header: "Live Bidding", rightButtonTitle: "See All", innerView: self.liveBidCollection, innerViewSize: .init(width: self.view.bounds.width, height: 250), buttonHandler: self.pushSeeAllArtVC)
        return container
    }()
    
    
    private lazy var hotItems:Container = {
        let hotItemsCollection = NFTArtCollection(orientation: .horizontal, itemSize: NFTArtCollection.smallCard)
        hotItemsCollection.collectionDelegate = self
        let collection = Container(header: "Hot Item", rightButtonTitle: "See all", innerView: hotItemsCollection, innerViewSize: .init(width: self.view.bounds.width, height: NFTArtCollection.smallCard.height + 20), buttonHandler: self.pushSeeAllArtVC)
        return collection
    }()
    
    private lazy var popularItems:Container = {
        let popularItems = NFTArtCollection(orientation: .horizontal, itemSize: NFTArtCollection.smallCard)
        popularItems.collectionDelegate = self
        let collection = Container(header: "Popular Item", rightButtonTitle: "See all", innerView: popularItems, innerViewSize: .init(width: self.view.bounds.width, height: NFTArtCollection.smallCard.height + 20), buttonHandler: self.pushSeeAllArtVC)
        return collection
    }()

    private lazy var topCollection:Container = {
        let container = Container(header: "Top Collection", rightButtonTitle: "View All", innerView: TopCollectionView(), innerViewSize: .init(width: UIScreen.main.bounds.width, height: 208),buttonHandler: self.pushSeeAllArtVC)
        return container
    }()
    
    private lazy var artTypes:NFTArtTypeCollectionView = {
        return NFTArtTypeCollectionView()
    }()
    
    private lazy var topSeller:Container = {
        let container = Container(header: "Top Seller", rightButtonTitle: "View all", innerView: TopSellerCollectionView(), innerViewSize: .init(width: UIScreen.main.bounds.width, height: 113), buttonHandler: self.pushSeeAllArtVC)
        print("(DEBUG) container intrinsic size : ",container.intrinsicContentSize)
//        container.backgroundColor = .red
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textLabel.frame = .init(origin: .zero, size: .init(width: 50, height: 50))
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.artTypes)
        self.scrollView.addSubview(self.bannerImageView)
        self.scrollView.addSubview(self.liveBidCollectionContainer)
        self.scrollView.addSubview(self.topCollection)
        self.scrollView.addSubview(self.hotItems)
        self.scrollView.addSubview(self.topSeller)
        self.scrollView.addSubview(self.popularItems)
        
//        self.hideNavigationBarLine()
        self.setupStatusBar()
        self.configNavBar()
    }
    
    private let logoView:UIView = {
        let logo:UIImageView = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        if let safeImage = UIImage(named: "logo"){
            logo.image = safeImage
        }

        logo.contentMode = .scaleAspectFill
        
        let titleView = CustomLabel(text: "NFTX", size: 20, weight: .bold, color: .appBlackColor, numOfLines: 1)

        
        let ethLogo:UIImageView = UIImageView()
        ethLogo.translatesAutoresizingMaskIntoConstraints = false
        if let safeImage = UIImage(named: "ethBasicLogo"){
            ethLogo.image = safeImage
        }

        ethLogo.contentMode = .scaleAspectFill
        
        let balanceView = CustomLabel(text: "0.1345", size: 14, weight: .regular, color: .appWhiteBackgroundColor, numOfLines: 1)
        balanceView.textAlignment = .right
        
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .appPurpleColor
        bgView.layer.cornerRadius = 16
        bgView.addSubview(balanceView)
        bgView.addSubview(ethLogo)
    
        let view = UIView()
        view.addSubview(logo)
        view.addSubview(titleView)
        view.addSubview(bgView)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 33),
            logo.heightAnchor.constraint(equalToConstant: 34),
            
            titleView.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 3),
            titleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bgView.widthAnchor.constraint(equalToConstant: 80),
            bgView.heightAnchor.constraint(equalToConstant: 30),
            
//            balanceView.topAnchor.constraint(equalTo: bgView,constant: 10),
            
            ethLogo.leadingAnchor.constraint(equalTo: bgView.leadingAnchor,constant: 12),
            ethLogo.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            
            balanceView.leadingAnchor.constraint(equalTo: ethLogo.trailingAnchor, constant: 8),
            balanceView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            balanceView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor,constant: -12)
            
        ])
        
        
        return view
    }()
    
    func configNavBar(){
        NSLayoutConstraint.activate([
            self.logoView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            self.logoView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        self.navigationItem.titleView = self.logoView
    }
    
    
    func popLivBidVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func pushSeeAllArtVC(){
        let liveBidVC = LiveBidDetailView()
        self.navigationController?.pushViewController(liveBidVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.bounds
        self.scrollView.contentSize = .init(width: self.view.frame.width, height: self.view.frame.height * 5)
        self.setupLayout()
    }
    
    private lazy var bannerImageView:UIImageView = {
        let imageView = UIImageView()
        if let safeImg = UIImage(named: "BannerSkeleton"){
            imageView.image = safeImg
        }
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        
       
        
        //LearnMoreImage
        let learnMoreBannerImage = UIImageView()
        learnMoreBannerImage.translatesAutoresizingMaskIntoConstraints = false
        learnMoreBannerImage.contentMode = .scaleAspectFit
        learnMoreBannerImage.image = .init(named: "LearnMoreBannerImage")
        imageView.addSubview(learnMoreBannerImage)
        
        learnMoreBannerImage.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,constant: -20).isActive = true
        learnMoreBannerImage.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 24).isActive = true
        learnMoreBannerImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        learnMoreBannerImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //titlView
        let bannerTitle = self.view.labelBuilder(text: "Collect and Sell extraordinary NFTs", size: 18, weight: .bold, color: .appWhiteBackgroundColor, numOfLines: 2, adjustFontSize: false)
        imageView.addSubview(bannerTitle)
        bannerTitle.leadingAnchor.constraint(equalTo: learnMoreBannerImage.leadingAnchor).isActive = true
        bannerTitle.topAnchor.constraint(equalTo: imageView.topAnchor,constant:20).isActive = true
        bannerTitle.bottomAnchor.constraint(equalTo: learnMoreBannerImage.topAnchor, constant: -24).isActive = true
        bannerTitle.widthAnchor.constraint(equalToConstant: 185).isActive = true
        
        return imageView
    }()
    
    func setupLayout(){
    
        self.artTypes.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0).isActive = true
        self.artTypes.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 50).isActive = true
        self.artTypes.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.artTypes.widthAnchor.constraint(equalTo:self.scrollView.widthAnchor).isActive = true
        
        self.bannerImageView.topAnchor.constraint(equalToSystemSpacingBelow: self.artTypes.bottomAnchor, multiplier: 3).isActive = true
        self.bannerImageView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,constant: 10).isActive = true
        self.bannerImageView.heightAnchor.constraint(equalToConstant: 132).isActive = true
        self.bannerImageView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor,constant: -20).isActive = true
        
        self.liveBidCollectionContainer.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.liveBidCollectionContainer.topAnchor.constraint(equalToSystemSpacingBelow: self.bannerImageView.bottomAnchor, multiplier: 3).isActive = true
        self.liveBidCollectionContainer.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        
        self.topSeller.topAnchor.constraint(equalTo: self.liveBidCollection.bottomAnchor, constant: 24).isActive = true
        self.topSeller.leadingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.topSeller.trailingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.topCollection.leadingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.topCollection.topAnchor.constraint(equalTo: self.topSeller.bottomAnchor,constant: 44).isActive = true
        self.topCollection.trailingAnchor.constraint(equalTo:self.scrollView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.hotItems.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.hotItems.topAnchor.constraint(equalTo: self.topCollection.bottomAnchor, constant: 24).isActive = true
        self.hotItems.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        
        self.popularItems.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.popularItems.topAnchor.constraint(equalTo: self.hotItems.bottomAnchor, constant: 24).isActive = true
        self.popularItems.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        
    }
    
}

//MARK: - NFTLiveBidCollectionDelegate
extension HomeViewController:NFTLiveBidCollectionDelegate{
    func viewAll(allArt: [NFTModel]) {
        let liveBidVC = LiveBidDetailView(nfts: allArt)
        self.navigationController?.pushViewController(liveBidVC, animated: true)
    }
    
    func viewNFT(art: NFTModel) {
        print("(DEBUG) selected An Art : ",art.title)
        self.navigationController?.pushViewController(NFTDetailArtViewController(nftArt: art), animated: true)
    }
}

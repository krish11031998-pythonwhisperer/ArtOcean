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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textLabel.frame = .init(origin: .zero, size: .init(width: 50, height: 50))
        self.navigationItem.titleView = self.textLabel
        self.navigationController?.navigationBar.tintColor = .white
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.artTypes)
        self.scrollView.addSubview(self.bannerImageView)
        self.scrollView.addSubview(self.liveBidCollectionContainer)
        self.scrollView.addSubview(self.topCollection)
        self.scrollView.addSubview(self.hotItems)
        self.scrollView.addSubview(self.popularItems)
        
        self.hideNavigationBarLine()
        self.setupStatusBar()
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
    
    private var bannerImageView:UIImageView = {
        let imageView = UIImageView()
        if let safeImg = UIImage(named: "Banner"){
            imageView.image = safeImg
        }
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        
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
        
        self.topCollection.leadingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.topCollection.topAnchor.constraint(equalTo: self.liveBidCollectionContainer.bottomAnchor,constant: 24).isActive = true
        self.topCollection.trailingAnchor.constraint(equalTo:self.scrollView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.hotItems.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.hotItems.topAnchor.constraint(equalTo: self.topCollection.bottomAnchor, constant: 24).isActive = true
        self.hotItems.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        
        self.popularItems.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.popularItems.topAnchor.constraint(equalTo: self.hotItems.bottomAnchor, constant: 24).isActive = true
        self.popularItems.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
//
//        self.newDropsCollectionContainer.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
//        self.newDropsCollectionContainer.topAnchor.constraint(equalTo: self.topCollection.bottomAnchor,constant: 24).isActive = true
//        self.newDropsCollectionContainer.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        
        
        
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

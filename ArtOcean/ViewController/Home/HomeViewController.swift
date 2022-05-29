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

    private lazy var liveBidCollectionContainer:Container = {
        let container = Container(header: "Live Bidding", rightButtonTitle: "See All", innerView: NFTLiveBiddingCollectionView(orientation: .horizontal), innerViewSize: .init(width: self.view.bounds.width, height: 250), buttonHandler: self.pushSeeAllArtVC)
        return container
    }()
    
    private lazy var newDropsCollectionContainer:Container = {
        let container = Container(header: "New Drop", rightButtonTitle: "See All", innerView: NFTLiveBiddingCollectionView(orientation: .horizontal), innerViewSize: .init(width: self.view.bounds.width, height: 250), buttonHandler: self.pushSeeAllArtVC)
        return container
    }()
    
    private lazy var topCollection:Container = {
        let container = Container(header: "Top Collection", rightButtonTitle: "View All", innerView: TopCollectionView(), innerViewSize: .init(width: UIScreen.main.bounds.width, height: 208),buttonHandler: self.pushSeeAllArtVC)
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textLabel.frame = .init(origin: .zero, size: .init(width: 50, height: 50))
        self.navigationItem.titleView = self.textLabel
        self.navigationController?.navigationBar.tintColor = .white
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.liveBidCollectionContainer)
        self.scrollView.addSubview(self.topCollection)
        self.scrollView.addSubview(self.newDropsCollectionContainer)
        
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
    
    func setupLayout(){
    
        self.liveBidCollectionContainer.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.liveBidCollectionContainer.topAnchor.constraint(equalTo: self.scrollView.topAnchor,constant: 50).isActive = true
        self.liveBidCollectionContainer.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        
        self.topCollection.leadingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.topCollection.topAnchor.constraint(equalTo: self.liveBidCollectionContainer.bottomAnchor,constant: 15).isActive = true
        self.topCollection.trailingAnchor.constraint(equalTo:self.scrollView.safeAreaLayoutGuide.trailingAnchor).isActive = true

        self.newDropsCollectionContainer.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.newDropsCollectionContainer.topAnchor.constraint(equalTo: self.topCollection.bottomAnchor,constant: 15).isActive = true
        self.newDropsCollectionContainer.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true

        
    
    }
    
}

//
//  LiveBidDetailView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/05/2022.
//

import UIKit

class LiveBidDetailView: UIViewController  {
    
    private lazy var liveBidCollection:NFTLiveBiddingCollectionView = {
        let collection = NFTLiveBiddingCollectionView(orientation: .vertical,itemSize: .init(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.3))
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.liveBidCollection)
        self.configNavigationBar()
        self.view.backgroundColor = .white
    }
    
    private func configNavigationBar(){
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.titleView = self.view.labelBuilder(text: "Live Bid", size: 18, weight: .bold, color: .appBlackColor, numOfLines: 1)
        self.navigationItem.leftBarButtonItem = self.backBarButton
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private lazy var backBarButton:UIBarButtonItem = {
        let backButton = UIBarButtonItem()
        let backButtonView = UIView()
        
    
        backButtonView.frame = .init(origin: .zero, size: .init(width:30,height:30))
        backButtonView.layer.borderColor = UIColor.appGrayColor.cgColor
        backButtonView.layer.borderWidth = 1
        backButtonView.layer.cornerRadius = 15
        
        let buttonView = UIImageView()
        buttonView.image = .init(systemName: "chevron.left",withConfiguration:UIImage.SymbolConfiguration(pointSize: 12, weight: .bold))
        buttonView.tintColor = .appBlackColor
        
        buttonView.frame.size = .init(width: 12, height: 12)
        buttonView.frame.origin = .init(x: backButtonView.frame.midX - buttonView.frame.width * 0.5, y: backButtonView.frame.midY - buttonView.frame.height * 0.5)
        
        backButtonView.addSubview(buttonView)
        
        backButton.customView = backButtonView
        backButton.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleBackButtonTap)))
        
        return backButton
    }()
    
    @objc func handleBackButtonTap(){
        print("(DEBUG) Tap Back Button was pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupLayout()
    }
    
    func setupLayout(){
        self.liveBidCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 5).isActive = true
        self.liveBidCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 40).isActive = true
        self.liveBidCollection.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor,constant: -10).isActive = true
        self.liveBidCollection.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor).isActive = true
//        self.liveBidCollection.frame = self.view.frame.inset(by: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        
    }
}

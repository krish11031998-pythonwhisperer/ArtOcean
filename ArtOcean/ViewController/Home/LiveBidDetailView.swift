//
//  LiveBidDetailView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/05/2022.
//

import UIKit

class LiveBidDetailView: UIViewController  {
        
    
    private var nfts:[NFTModel]? = nil
    
    init(nfts:[NFTModel]? = nil){
        self.nfts = nfts
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var liveBidCollection:NFTArtCollection = {
        let collection = NFTArtCollection(nfts: self.nfts,orientation: .vertical,itemSize: .init(width: UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.1), height: 300))
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.liveBidCollection)
        self.configNavigationBar()
        self.view.backgroundColor = .white
//        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func configNavigationBar(){
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.titleView = self.view.labelBuilder(text: "Live Bid", size: 18, weight: .bold, color: .appBlackColor, numOfLines: 1)
        self.navigationItem.leftBarButtonItem = self.backBarButton
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private lazy var backBarButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        
        let backButton = CustomButton.backButton
        backButton.handler = {
            self.navigationController?.popViewController(animated: true)
        }
        
        barButton.customView = backButton
        
        return barButton
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
        self.liveBidCollection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.liveBidCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 40).isActive = true
        self.liveBidCollection.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.liveBidCollection.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor).isActive = true
//        self.liveBidCollection.frame = self.view.frame.inset(by: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        
    }
}

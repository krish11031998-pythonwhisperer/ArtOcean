//
//  StatisticsViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    
    private var pageVC:CustomPageSelectorViewController!
    private var pages:[String:UIViewController] = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPages()
        self.setupPageViewController()
        self.configNavbar()
        self.setupLayout()
    }
    
    
    func setupPageViewController(){
        self.pageVC = .init(pages: self.pages)
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParent: self)
    }
    
    func setupPages(){
        let ranking = StatisticCollectionView(cellType: .ranking)
        ranking.buttonDelegate = self
        let activity = StatisticCollectionView(cellType: .activity,data: NFTArtOfferSection.items)
        activity.buttonDelegate = self
        self.pages =  [StatisticsTab.ranking.rawValue:ranking,StatisticsTab.activity.rawValue: activity]
    }

    func configNavbar(){
        let searchButton = CustomButton(name: "search", handler: nil, autolayout: false)
        let label = CustomLabel(text: "Statistics", size: 22, weight: .bold, color: .appBlackColor, numOfLines: 1)
        label.translatesAutoresizingMaskIntoConstraints = true
        self.navigationItem.leftBarButtonItem = .init(customView: label)
        self.navigationItem.rightBarButtonItem = .init(customView: searchButton)
        self.setupStatusBar()
    }
    
    func setupLayout(){
        self.pageVC.view.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.leadingAnchor, multiplier: 3).isActive = true
        self.view.trailingAnchor.constraint(equalToSystemSpacingAfter: self.pageVC.view.trailingAnchor, multiplier: 3).isActive = true
        self.pageVC.view.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 100).isActive = true
        self.view.bottomAnchor.constraint(equalToSystemSpacingBelow: self.pageVC.view.bottomAnchor, multiplier: 3).isActive = true
    }
    
}


//MARK: - StatisticsViewController CustomButtonDelegate
extension StatisticsViewController:CustomButtonDelegate{
    
    func handleTap(_ data: Any) {
        print("(DEBUG) clicked on : ",data)
        if let safeArt = data as? NFTArtOffer,let nft = safeArt.nft{
            self.navigationController?.pushViewController(NFTDetailArtViewController(nftArt: nft), animated: true)
        }else{
            self.navigationController?.pushViewController(AccountViewController(), animated: true)
        }
    }
    
}

//MARK: - SlideSelectorDelegate
extension StatisticsViewController:SlideSelectorDelegate{
    
    func handleSelect(_ id: String) {
        print("(DEBUG) clicked on id : ",id)
        self.pageVC.movePages(page: id)
    }
    
}


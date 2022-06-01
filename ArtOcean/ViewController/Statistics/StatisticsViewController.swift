//
//  StatisticsViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    private let sliderView = SliderSelector(tabs: ["Ranking","Activity"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavbar()
        self.setupViews()
        self.setupLayout()
    }

    func configNavbar(){
        let searchButton = CustomButton(name: "search", handler: nil, autolayout: false)
        let label = CustomLabel(text: "Statistics", size: 22, weight: .bold, color: .appBlackColor, numOfLines: 1)
        label.translatesAutoresizingMaskIntoConstraints = true
        self.navigationItem.leftBarButtonItem = .init(customView: label)
        self.navigationItem.rightBarButtonItem = .init(customView: searchButton)
    }
    
    func setupViews(){
        self.view.addSubview(sliderView)
        self.view.addSubview(self.collectionView)
    }
    
    private let collectionView = StatisticCollectionView()
    
    func setupLayout(){
        self.sliderView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 100).isActive = true
        self.sliderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 24).isActive = true
        self.sliderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -24).isActive = true
        self.sliderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -24).isActive = true
        self.sliderView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        self.collectionView.topAnchor.constraint(equalToSystemSpacingBelow: self.sliderView.bottomAnchor, multiplier: 4).isActive = true
        self.collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.leadingAnchor, multiplier: 3).isActive = true
        self.view.trailingAnchor.constraint(equalToSystemSpacingAfter: self.collectionView.trailingAnchor, multiplier: 3).isActive = true
        self.view.bottomAnchor.constraint(equalToSystemSpacingBelow: self.collectionView.bottomAnchor, multiplier: 6).isActive = true
    }
    
}

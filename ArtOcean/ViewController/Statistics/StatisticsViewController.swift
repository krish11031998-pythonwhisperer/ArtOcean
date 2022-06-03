//
//  StatisticsViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    
    private var pageVC:PageViewController!
    private var currentVC:UIViewController? = nil
    private var pages:[String:UIViewController] = .init()
    
    
    private lazy var sliderView:SliderSelector = {
        let view = SliderSelector(tabs: [.ranking,.activity])
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPages()
        self.setupPageViewController()
        self.configNavbar()
        self.setupViews()
        self.setupLayout()
    }
    
    
    func setupPageViewController(){
        self.pageVC = .init(pages: self.pages)
        self.pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(self.pageVC)
        self.pageVC.didMove(toParent: self)
        self.pageVC.setViewControllers([self.pages.values.first!], direction: .forward, animated: true)
        self.currentVC = self.pages.values.first
    }
    
    func setupPages(){
        let ranking = StatisticCollectionView(cellType: .ranking)
        ranking.buttonDelegate = self
        let activity = StatisticCollectionView(cellType: .activity)
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
    
    func setupViews(){
        self.view.addSubview(sliderView)
        self.view.addSubview(self.pageVC!.view)
    }
    
    func setupLayout(){
        self.sliderView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 100).isActive = true
        self.sliderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 24).isActive = true
        self.sliderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -24).isActive = true
        self.sliderView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        if let safePageVC = self.pageVC{
            safePageVC.view.topAnchor.constraint(equalToSystemSpacingBelow: self.sliderView.bottomAnchor, multiplier: 4).isActive = true
            safePageVC.view.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.leadingAnchor, multiplier: 3).isActive = true
            self.view.trailingAnchor.constraint(equalToSystemSpacingAfter: safePageVC.view.trailingAnchor, multiplier: 3).isActive = true
            self.view.bottomAnchor.constraint(equalToSystemSpacingBelow: safePageVC.view.bottomAnchor, multiplier: 6).isActive = true
        }
    }
    
}


//MARK: - StatisticsViewController CustomButtonDelegate
extension StatisticsViewController:CustomButtonDelegate{
    
    func handleTap(_ data: Any) {
        print("(DEBUG) clicked on : ",data)
        self.navigationController?.pushViewController(AccountViewController(), animated: true)
    }
    
}

//MARK: - SlideSelectorDelegate
extension StatisticsViewController:SlideSelectorDelegate{
    
    func handleSelect(_ id: String) {
        print("(DEBUG) clicked on id : ",id)
        self.pageVC.movePages(page: id)
    }
    
}


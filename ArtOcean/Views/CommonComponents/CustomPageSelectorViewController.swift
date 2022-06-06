//
//  CustomPageSelectorViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 03/06/2022.
//

import Foundation
import UIKit

class CustomPageSelectorViewController:UIViewController{
    private var pages:[String:UIViewController] = .init()
    private var selectedPage:String
    private var pageVC:UIPageViewController!
    private var slideSelector:SliderSelector!
    
    init(pages:[String:UIViewController]){
        self.pages = pages
        self.selectedPage = pages.keys.first ?? ""
        super.init(nibName: nil, bundle: nil)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.setupSlideSelector()
        self.setupPageViewController()
        self.setupLayout()
    }
    
    var pageKeys:[String]{
        return self.pages.keys.sorted()
    }
    
    func setupSlideSelector(){
        self.slideSelector = .init(tabs: self.pageKeys)
        self.slideSelector.delegate = self
        self.view.addSubview(self.slideSelector)
    }
    
    func setupPageViewController(){
        self.pageVC = .init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [.interPageSpacing: 20])
        self.pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParent: self)
        if let firstPageKey = self.pageKeys.first,let firstPage = self.pages[firstPageKey]{
            self.pageVC.setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func movePages(page pageStr:String){
        guard let presentPageidx = Array(self.pages.keys).firstIndex(of: self.selectedPage),let nextPageIdx = Array(self.pages.keys).firstIndex(of: pageStr),let page = self.pages[pageStr] else {return}
        print("(DEBUG) presentPageidx : \(presentPageidx) and nextPageIdx : \(nextPageIdx)")
        self.selectedPage = pageStr
        self.pageVC.setViewControllers([page], direction: presentPageidx > nextPageIdx ? .reverse : .forward, animated: true)
    }
    
    
    func setupLayout(){
        self.slideSelector.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.slideSelector.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.slideSelector.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.slideSelector.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.pageVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.pageVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.pageVC.view.topAnchor.constraint(equalTo: self.slideSelector.bottomAnchor, constant: 24).isActive = true
        self.pageVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
}

//MARK: - SlideSelectorDelegate
extension CustomPageSelectorViewController:SlideSelectorDelegate{
    func handleSelect(_ id: String) {
        self.movePages(page: id)
    }
}

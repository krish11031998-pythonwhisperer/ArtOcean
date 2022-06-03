//
//  PageViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 03/06/2022.
//

import Foundation
import UIKit

class PageViewController:UIPageViewController{
    private var pages:[String:UIViewController]
    private var selectedPage:String
    init(pages:[String:UIViewController]){
        self.pages = pages
        self.selectedPage = pages.keys.first ?? ""
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [.interPageSpacing:20])
        self.setViewControllers([self.pages.values.first!], direction: .forward, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func movePages(page pageStr:String){
        guard let presentPageidx = Array(self.pages.keys).firstIndex(of: self.selectedPage),let nextPageIdx = Array(self.pages.keys).firstIndex(of: pageStr),let page = self.pages[pageStr] else {return}
        print("(DEBUG) presentPageidx : \(presentPageidx) and nextPageIdx : \(nextPageIdx)")
        self.selectedPage = pageStr
        self.setViewControllers([page], direction: presentPageidx > nextPageIdx ? .reverse : .forward, animated: true)
    }
}


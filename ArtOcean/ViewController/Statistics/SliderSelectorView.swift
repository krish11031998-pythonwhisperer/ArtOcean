//
//  SliderSelectorView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 01/06/2022.
//

import Foundation
import UIKit


class SliderSelector:UIView{
    
    private var selectedTabName:String
    private var hoverViewCenterX:NSLayoutConstraint? = nil
    private var tabs:[String]
    
    init(tabs:[String]){
        self.tabs = tabs
        
        if let firstTabName = tabs.first{
            self.selectedTabName = firstTabName
        }else{
            self.selectedTabName = ""
        }
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor(red: 0.953, green: 0.969, blue: 0.976, alpha: 1)
        self.tabStackBuilder(tabs: tabs)
        self.addSubview(self.selectedHoverView)
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var selectedHoverView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        view.backgroundColor = .white
        
        if let selectedTab = self.tabsIndicators.firstIndex(where: {$0.accessibilityIdentifier == self.selectedTabName}){
            let tabView = self.tabsIndicators[selectedTab]
            view.addSubview(tabView)
            
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: tabView.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: tabView.centerYAnchor)
            ])
        }
        
        
        return view
    }()
    
    private lazy var tabsIndicators:[UIView] = {
        let views:[UIView] = self.tabs.compactMap { tab in
            let view = UIView()
            let imageView = UIImageView(image: .init(named: tab.lowercased()))
            
            view.accessibilityIdentifier = tab
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.tintColor = .appPurpleColor
            imageView.contentMode = .scaleAspectFit
            
            let label = CustomLabel(text: tab, size: 14, weight: .regular, color: .appGrayColor, numOfLines: 1, adjustFontSize: true)
            
            label.textAlignment = .left
            
            view.addSubview(imageView)
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                imageView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -15),
                imageView.widthAnchor.constraint(equalToConstant: 15),
                imageView.heightAnchor.constraint(equalToConstant:15),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 6.5),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            return view
        }
        return views
    }()

    
    func tabStackBuilder(tabs:[String]){
        let ratios = Array(repeating: CGFloat(1)/CGFloat(tabsIndicators.count), count: tabsIndicators.count)
        print("(DEBUG) ratios : ",ratios)
        let stackView = UIView.StackBuilder(views: tabsIndicators, ratios: [0.5,0.5], spacing: 10, axis: .horizontal)
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5),
            stackView.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -5)
        ])
    }
    
    
    override var intrinsicContentSize: CGSize{
        return .init(width: UIScreen.main.bounds.width - 20, height: 50)
    }
    
    private func setupLayout(){
        self.selectedHoverView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 2).isActive = true
        self.selectedHoverView.topAnchor.constraint(equalTo: self.topAnchor,constant: 2).isActive = true
        self.selectedHoverView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -2).isActive = true
        self.selectedHoverView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5,constant: -4).isActive = true
    }
    
}

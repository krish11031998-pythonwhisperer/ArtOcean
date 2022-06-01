//
//  NFTDetailHeroHeaderSection.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 01/06/2022.
//

import Foundation
import UIKit

class NFTHeroHeaderView:UIView{
    
    //MARK: - View Properties
    private var onCloseHandler:(() -> Void)
    
    //MARK: - Views
    private lazy var backgroundImageView:CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 0,gradientColors: [UIColor.white.withAlphaComponent(1),UIColor.white.withAlphaComponent(0.2)])
        return imageView
    }()
    
    private let leftButton:CustomButton
    
    private let titleView:CustomLabel
    
    //MARK: - View LifeCycle and Init
    
    init(nft:NFTModel,handler:@escaping (() -> Void)){
        self.leftButton = CustomButton(systemName: "chevron.left", handler: handler, autolayout: true)
        self.titleView = CustomLabel(text: nft.title ?? "XXXXX", size: 18, weight: .bold, color: .appBlackColor, numOfLines: 1)
        self.onCloseHandler = handler
        super.init(frame:.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setupViews()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        self.addSubview(self.backgroundImageView)
        self.addSubview(leftButton)
        self.addSubview(titleView)
    }
    
    public func updatebackgroundImage(_ img:UIImage){
        DispatchQueue.main.async { [weak self] in
            self?.backgroundImageView.image = img
        }
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundImageView.widthAnchor.constraint(equalTo:self.widthAnchor),
            self.backgroundImageView.heightAnchor.constraint(equalTo:self.heightAnchor),
            leftButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 3),
            leftButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 2),
            titleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: leftButton.topAnchor),
            titleView.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor)
        ])
    }
    
    
    
}

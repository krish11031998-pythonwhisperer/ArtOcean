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
    private var height:CGFloat
    
    //MARK: - Views
    private lazy var backgroundImageView:CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 0)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var heroHeaderView:StreachyHeaderView = StreachyHeaderView(height: self.height, innerView: backgroundImageView)
    
    private let leftButton:CustomButton

    
    //MARK: - View LifeCycle and Init
    
    init(nft:NFTModel,height:CGFloat,handler:@escaping (() -> Void)){
        self.leftButton = CustomButton(systemName: "chevron.left", handler: handler, autolayout: true)
        self.height = height
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
        self.addSubview(self.heroHeaderView)
        self.addSubview(leftButton)
    }
    
    public func updatebackgroundImage(_ img:UIImage){
        DispatchQueue.main.async { [weak self] in
            self?.backgroundImageView.image = img
        }
    }
    
    public func headerViewScrolled(_ scrollView:UIScrollView){
        self.heroHeaderView.StretchOnScroll(scrollView)
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            self.heroHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.heroHeaderView.topAnchor.constraint(equalTo: self.topAnchor),
            self.heroHeaderView.widthAnchor.constraint(equalTo:self.widthAnchor),
            self.heroHeaderView.heightAnchor.constraint(equalToConstant: self.height),
            leftButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 3),
            leftButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 5),
        ])
    }
    
    
    
}

//
//  AccountHeaderView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 02/06/2022.
//

import Foundation
import UIKit

class AccountHeaderView:UIView{
    
    private var handler:(() -> Void)? = nil
    private var imgHeightConstraint:NSLayoutConstraint? = nil
    private var imgTopAnchor:NSLayoutConstraint? = nil
    private var height:CGFloat = .zero
    
    private let headerImageView:CustomImageView = {
        let image = CustomImageView(named: "CustomProfileImage", cornerRadius: 0, maskedCorners: nil)
        return image
    }()
    
    private lazy var backButton:CustomButton = {
        let button  = CustomButton(systemName: "chevron.left", handler: self.handler, autolayout: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init(height:CGFloat = 200,handler:@escaping (() -> Void)) {
        self.height = height
        super.init(frame: .zero)
        self.handler = handler
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupViews()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews(){
        self.addSubview(self.headerImageView)
        self.addSubview(self.backButton)
    }
    
    func setupLayout(){
        self.headerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.headerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.imgTopAnchor = self.headerImageView.topAnchor.constraint(equalTo: self.topAnchor)
        self.imgTopAnchor?.isActive = true
        self.imgHeightConstraint = self.headerImageView.heightAnchor.constraint(equalToConstant: self.height)
        self.imgHeightConstraint?.isActive = true
        
        self.backButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2).isActive = true
        self.backButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 5).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    public func viewAnimationWithScroll(_ scrollView:UIScrollView){
        print("(DEBUG) scrollViewOffset : ",scrollView.contentOffset,scrollView.contentInset)
        if scrollView.contentOffset.y < 0 {
            self.headerImageView.clipsToBounds = false
            self.imgTopAnchor?.constant = scrollView.contentOffset.y
            self.imgHeightConstraint?.constant = max(self.height - scrollView.contentOffset.y,height)
            
        }
    }
}

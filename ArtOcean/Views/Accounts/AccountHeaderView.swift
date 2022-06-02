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
    
    private let headerImageView:CustomImageView = {
        let image = CustomImageView(named: "CustomProfileImage", cornerRadius: 0, maskedCorners: nil)
        return image
    }()
    
    private lazy var backButton:CustomButton = {
        let button  = CustomButton(systemName: "chevron.left", handler: self.handler, autolayout: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init(handler:@escaping (() -> Void)) {
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
        self.headerImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.headerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.headerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.backButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2).isActive = true
        self.backButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 4).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

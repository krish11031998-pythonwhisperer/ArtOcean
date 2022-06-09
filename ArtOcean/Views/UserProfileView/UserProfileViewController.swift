//
//  ProfileViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 09/06/2022.
//

import Foundation
import UIKit

class UserProfileViewController:UIViewController{
    
    private let profileHeader:UILabel = CustomLabel(text: "Profile", size: 22, weight: .bold, color: .black, numOfLines: 1, adjustFontSize: true)
    
    private let settingButton = CustomButton(frame: .init(origin: .zero, size: .init(width: 40, height: 40)), name: "settings", handler: nil)
    
    private let userProfileView:UIImageView = CustomImageView(named: "userProfileImage", cornerRadius: 32)
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.leftBarButtonItem = .init(customView: self.profileHeader)
        self.navigationItem.rightBarButtonItem = .init(customView: settingButton)
        self.setupStatusBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews(){
        self.userProfileView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.userProfileView)
    }
    
    func setupLayout(){
        self.userProfileView.topAnchor.constraint(equalToSystemSpacingBelow: self.view.topAnchor, multiplier: 6).isActive = true
        self.userProfileView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    
}

//
//  NFTDetailViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 29/05/2022.
//

import Foundation
import UIKit

class NFTDetailArtViewController:UIViewController{
    
    private lazy var imageView:CustomImageView = CustomImageView(cornerRadius: 16)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.addSubview(self.imageView)
        self.setupLayout()
        self.setupStatusBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 80).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.35).isActive = true
    }
}

//
//  NFTArtInteractiveInfoView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 01/06/2022.
//

import Foundation
import UIKit

class NFTArtInteractiveInfoView:UIView{
    
    //MARK: - Views
    private lazy var timeLeftLabel:UIView = {
        let label = CustomLabel(text: "3h 12m 36s left",weight: .medium, color: .appPurpleColor, numOfLines: 3)
        label.textAlignment = .center
        let view = UIView()
        view.addSubview(label)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = .appPurple50Color
        view.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 12),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
        ])
        
        return view
    }()
    
    private let shareButton:CustomButton = CustomButton(name: "share", handler: nil, autolayout: true)
    
    private let loveButton:CustomButton = CustomButton(name: "heart", handler: nil, autolayout: true)
    
    
    init(nft:NFTModel){

        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.timeLeftLabel)
        self.addSubview(self.shareButton)
        self.addSubview(self.loveButton)
        self.setupLayout()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLayout(){
        
        self.timeLeftLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.timeLeftLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.timeLeftLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.loveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.loveButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.shareButton.trailingAnchor.constraint(equalTo: self.loveButton.leadingAnchor, constant: -16).isActive = true
        self.shareButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        
    }
}

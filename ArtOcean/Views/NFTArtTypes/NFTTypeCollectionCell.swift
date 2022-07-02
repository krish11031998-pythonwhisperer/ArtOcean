//
//  NFTTypeCollectionCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

class NFTTypeCollectionCell:UICollectionViewCell{
    
    public static let identifier:String = "NFTTypeCollectionCell"
    
    private let imgView:CustomImageView = {
        let img = CustomImageView(cornerRadius: 0)
        img.contentMode = .scaleAspectFit
        img.backgroundColor = .clear
        return img
    }()
    
    private lazy var typeLabel:UILabel = self.labelBuilder(text: "", size: 14, weight: .bold, color: .black, numOfLines: 1)
    
    private lazy var stackView:UIStackView = {
        let stack = UIView.StackBuilder(views: [self.imgView,self.typeLabel], ratios: [0.3,0.7], spacing: 10, axis: .horizontal)

        return stack
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
//        self.addSubview(self.stackView)
        self.addSubview(self.imgView)
        self.addSubview(self.typeLabel)
        self.layer.cornerRadius = 8
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateTypeCell(img:String,type:String,color:UIColor){
        
        if let img = UIImage(named: img){
            DispatchQueue.main.async {
                self.imgView.image = img
            }
        }
        
        DispatchQueue.main.async {
            self.typeLabel.text = type
            self.typeLabel.textAlignment = .center
            self.backgroundColor = color
        }
        
    }
    
    func setupLayout(){
        self.imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16).isActive = true
        self.imgView.topAnchor.constraint(equalTo: self.topAnchor,constant: 12).isActive = true
        self.imgView.heightAnchor.constraint(equalToConstant:16).isActive = true
        self.imgView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        self.typeLabel.leadingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: 8).isActive = true
        self.typeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.typeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
    
	override func prepareForReuse() {
		super.prepareForReuse()
		backgroundColor = .clear
		imgView.image = nil
	}
}

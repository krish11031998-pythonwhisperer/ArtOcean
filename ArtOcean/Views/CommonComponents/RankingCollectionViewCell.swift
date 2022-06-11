//
//  RankingCollectionViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 03/06/2022.
//

import Foundation
import UIKit

protocol UserProtocol{
    func viewUser(_ data:Any)
}

class StatisticRankingCollectionViewCell:UICollectionViewCell,ConfirgurableCell{

    static var identifier:String = "StatisticRankingCollectionViewCell"
    
    private lazy var imageView:CustomImageView = CustomImageView(cornerRadius: 20)
    
    public var buttonDelegate:CustomButtonDelegate? = nil
    
    //UserInfo
    private lazy var name:UILabel = CustomLabel(text: "Shapire Cole", size: 14, weight: .medium, color: .appBlackColor, numOfLines: 1, adjustFontSize: true)
    
    private lazy var userName:UILabel = CustomLabel(text: "@shpre", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1, adjustFontSize: true)
    
    private lazy var userInfoView:UIStackView = UIView.StackBuilder(views: [name,userName], ratios: [0.5,0.5], spacing: 5, axis: .vertical)
    
    //PricePercentInfo
    private lazy var priceLabel:UILabel = CustomLabel(text: "316,836 ETH", size: 14, weight: .medium, color: .appBlackColor, numOfLines: 1, adjustFontSize: true)
    
    private lazy var percentLabel:UILabel = CustomLabel(text: "+23.35", size: 12, weight: .medium, color: .appGreenColor, numOfLines: 1, adjustFontSize: true)
    
    private lazy var pricePercentLabel:UIStackView = UIView.StackBuilder(views: [priceLabel,percentLabel], ratios: [0.5,0.5], spacing: 5, axis: .vertical)
    
    //NumberLabel
    private let numberLabel:UILabel = CustomLabel(text: "1", size: 14, weight: .medium, color: .appBlackColor, numOfLines: 1, adjustFontSize: false)
    
    public func updateCell(idx:Int){
        self.numberLabel.text = "\(idx)"
    }
    
    //MainStackView
    private lazy var stack:UIStackView = {
        let stack = UIView.StackBuilder(views: [userInfoView,pricePercentLabel], ratios: [0.5,0.5], spacing: 10, axis: .horizontal)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.priceLabel.textAlignment = .right
        self.percentLabel.textAlignment = .right
        
        self.addSubview(self.numberLabel)
        self.addSubview(imageView)
        self.addSubview(stack)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        
        self.numberLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.numberLabel.trailingAnchor,constant: 10).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.backgroundColor = .black
        self.imageView.layer.cornerRadius = 20
        
        self.stack.leadingAnchor.constraint(equalToSystemSpacingAfter: self.imageView.trailingAnchor, multiplier: 1.5).isActive = true
        self.stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.stack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    //Handler
    @objc func handleTap(){
        self.buttonDelegate?.handleTap?("nil")
    }
}


////MARK: - ReusableConfigurableCell
extension StatisticRankingCollectionViewCell{

    func configure(_ data: Item) {
        switch data{
        case .user(let user):
            self.updateCellWithData(user)
        default:
            print("(DEBUG) Wrong Data Type Provided!")
        }
    }

    
    func updateCellWithData(_ user:User){
        if let safeImgName = user.image{
            if let image = UIImage(named: safeImgName){
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }else{
                self.imageView.updateImageView(url: safeImgName)
            }
        }
        
        if let name = user.name{
            DispatchQueue.main.async {
                self.name.text = name
            }
        }
        
        
        if let username = user.username{
            DispatchQueue.main.async {
                self.userName.text = username
            }
        }
        
        if let worth = user.worthValue{
            DispatchQueue.main.async {
                self.priceLabel.text = "\(worth)"
            }
        }
        
        if let percent = user.profit{
            DispatchQueue.main.async {
                self.percentLabel.text = "\(percent)"
            }
        }
    }
}

//
//  TopCollectionTableCellViewTableViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import UIKit

class TopCollectionTableCellViewTableViewCell: UITableViewCell {
    
    public static var identifier:String = "TopCollectionCell"
    
    private lazy var collectionName:UILabel = self.labelBuilder(text: "Bored Apes Yacht Club", size: 16, weight: .bold, color: .appBlackColor, numOfLines: 1)
    
    private lazy var priceOfCollection:UILabel = self.labelBuilder(text: "4,218", size: 16, weight: .bold, color: .appBlackColor, numOfLines: 1)
    
    private lazy var ownerLabel:UILabel = self.labelBuilder(text: "RoycoJack", size: 14, weight: .regular, color: .appGrayColor, numOfLines: 1)
    
    private lazy var percentageLabel:UILabel = self.labelBuilder(text: "-32.01", size: 14, weight: .regular, color: .appGreenColor, numOfLines: 1)
    
    private lazy var orderNumberLabel:UILabel = self.labelBuilder(text: "1", size: 12, weight: .bold, color: .appBlackColor, numOfLines: 1)
    
    private lazy var collectionImage:UIImageView = {
        let image = self.imageView(cornerRadius: 15, autoLayout: false)
        image.backgroundColor = .black
        return image
    }()
    
    
    private lazy var collectionNameAndOwnerStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.collectionName,self.ownerLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private lazy var collectionPriceInfo:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.priceOfCollection,self.percentageLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var imageAndGroupIcon:UIView = {
        self.collectionImage.translatesAutoresizingMaskIntoConstraints = false
        self.collectionImage.layer.cornerRadius = 23
        
        self.orderNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.orderNumberLabel.backgroundColor = .appWhiteBackgroundColor
        self.orderNumberLabel.layer.cornerRadius = 11
        self.orderNumberLabel.textAlignment = .center
        self.orderNumberLabel.clipsToBounds = true
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.collectionImage)
        view.addSubview(self.orderNumberLabel)
        
        NSLayoutConstraint.activate([
            self.collectionImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.collectionImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.collectionImage.widthAnchor.constraint(equalToConstant: 46),
            self.collectionImage.heightAnchor.constraint(equalToConstant: 46),
            
            self.orderNumberLabel.centerXAnchor.constraint(equalTo: self.collectionImage.trailingAnchor, constant: -2.5),
            self.orderNumberLabel.bottomAnchor.constraint(equalTo: self.collectionImage.bottomAnchor),
            self.orderNumberLabel.widthAnchor.constraint(equalToConstant: 22),
            self.orderNumberLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(self.imageAndGroupIcon)
        self.addSubview(self.collectionPriceInfo)
        self.addSubview(self.collectionNameAndOwnerStack)
        self.selectedBackgroundView = UIView()
        selectedBackgroundView?.clearView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            self.bouncyButtonClick {
                print("(DEBUG) Clicked on TableCell!")
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    
    func setupLayout(){
        
        self.imageAndGroupIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageAndGroupIcon.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.imageAndGroupIcon.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        
        self.collectionNameAndOwnerStack.leadingAnchor.constraint(equalTo: self.imageAndGroupIcon.trailingAnchor,constant: 10).isActive = true
        self.collectionNameAndOwnerStack.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        self.collectionNameAndOwnerStack.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.5).isActive = true
        
        self.collectionPriceInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10).isActive = true
        self.collectionPriceInfo.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
    }
    
    

}

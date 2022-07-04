//
//  TopCollectionTableCellViewTableViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import UIKit

struct TopCollectionData{
	var name:String
	var price:Double
	var owner:String
	var	percentage:Double
	var orderNumber:Int
	
	static var test:TopCollectionData{
		return .init(name: "Bored Apes Yacht Club", price: 4218.0, owner: "RoycoJack", percentage: -32.01, orderNumber: 1)
	}
}

class TopCollectionTableCell: ConfigurableCell {
    
    public static var identifier:String = "TopCollectionCell"
    
    private lazy var collectionName:UILabel = CustomLabel(text: "Bored Apes Yacht Club", size: 16, weight: .bold, color: .appBlackColor, numOfLines: 1)
    
    private lazy var priceOfCollection:UILabel = CustomLabel(text: "4,218", size: 16, weight: .bold, color: .appBlackColor, numOfLines: 1)
    
    private lazy var ownerLabel:UILabel = CustomLabel(text: "RoycoJack", size: 14, weight: .regular, color: .appGrayColor, numOfLines: 1)
    
    private lazy var percentageLabel:UILabel = CustomLabel(text: "-32.01", size: 14, weight: .regular, color: .appGreenColor, numOfLines: 1)
    
    private lazy var orderNumberLabel:UILabel = CustomLabel(text: "1", size: 12, weight: .bold, color: .appBlackColor, numOfLines: 1)
    
    private lazy var collectionImage:UIImageView = {
        let image = self.imageView(cornerRadius: 15, autoLayout: false)
        image.backgroundColor = .black
        return image
    }()
    
    private let mainStack:UIStackView = {
        let stack = UIStackView()
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var collectionNameAndOwnerStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.collectionName,self.ownerLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 5
        
        stack.setContentHuggingPriority(.init(249), for: .horizontal)
        stack.setContentCompressionResistancePriority(.init(749), for: .horizontal)

        return stack
    }()
    
    
    private lazy var collectionPriceInfo:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.priceOfCollection,self.percentageLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 5
        
        
        self.priceOfCollection.setContentHuggingPriority(.init(249), for: .vertical)
        self.priceOfCollection.setContentCompressionResistancePriority(.init(749), for: .vertical)

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
            collectionImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionImage.widthAnchor.constraint(equalToConstant: 46),
            collectionImage.heightAnchor.constraint(equalToConstant: 46),
            collectionImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            orderNumberLabel.centerXAnchor.constraint(equalTo: collectionImage.trailingAnchor, constant: -2.5),
            orderNumberLabel.bottomAnchor.constraint(equalTo: collectionImage.bottomAnchor),
            orderNumberLabel.widthAnchor.constraint(equalToConstant: 22),
            orderNumberLabel.heightAnchor.constraint(equalToConstant: 22)
        ])

        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        addSubview(mainStack)
        mainStack.addArrangedSubview(imageAndGroupIcon)
        mainStack.addArrangedSubview(collectionNameAndOwnerStack)
        mainStack.addArrangedSubview(collectionPriceInfo)
			
        self.selectedBackgroundView = UIView()
        selectedBackgroundView?.clearView()
		
		self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    
    func setupLayout(){
        
		mainStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,constant: 16).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,constant: -16).isActive = true
        mainStack.topAnchor.constraint(equalTo: topAnchor,constant: 5).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5).isActive = true
		heightAnchor.constraint(equalToConstant: 65).isActive = true
    }
    
	func configureCell(with model: TopCollectionData) {
		collectionName.text = model.name
		priceOfCollection.text = String(format:"%.2f",model.price)
		ownerLabel.text = model.owner
		percentageLabel.text = String(format: "%.2f", model.percentage)
		orderNumberLabel.text = "\(model.orderNumber)"
	}

}

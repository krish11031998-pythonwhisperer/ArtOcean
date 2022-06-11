//
//  TransactionCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 11/06/2022.
//

import Foundation
import UIKit

class TransactionViewCell:UITableViewCell{
    
    static var identifier:String = "TransactionCell"
    var txn:TransactionModel? = nil
    
    private let txnImage:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var txnImageBackground:UIView = {
        let view = UIView(frame: .init(origin: .zero, size: .init(width: 40, height: 40)))
        view.layer.cornerRadius = 20
        view.backgroundColor = .appGrayColor.withAlphaComponent(0.35)
        view.addSubview(txnImage)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            txnImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            txnImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }()
    
    private lazy var stackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [txnImageBackground,txnValueInfo,txnInfoView])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let txnValueInfo:CustomLabel = {
        let label = CustomLabel(text: "", size: 14, weight: .medium, color: .black, numOfLines: 1, adjustFontSize: true, autoLayout: false)
        label.setContentHuggingPriority(.init(249), for: .horizontal)
        label.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        return label
    }()
    
    private let txnType:CustomLabel = CustomLabel(text: "", size: 14, weight: .medium, color: .appBlackColor, numOfLines: 1, adjustFontSize: true)
    
    private let timeInfo:CustomLabel = .init(text: "", size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1, adjustFontSize: false)
    
    private lazy var txnInfoView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        
        txnType.textAlignment = .right
        timeInfo.textAlignment = .right
        
        stack.addArrangedSubview(txnType)
        stack.addArrangedSubview(timeInfo)
        
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(stackView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupLayout(){
        
        txnImageBackground.widthAnchor.constraint(equalToConstant: 40).isActive = true
        txnImageBackground.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    public func configureCell(txn:TransactionModel){
        switch txn.type{
            case .receive:
                txnImage.image = .init(named: "arrow-up")?.withTintColor(.appGreenColor)
            case .send:
                txnImage.image = .init(named: "arrow-up-right")?.withTintColor(.appRedColor)
            default:
                print("No Image")
        }
        
        txnType.text = txn.type.rawValue.capitalized
        
        timeInfo.text = txn.dayTimes + "days ago"
        
        txnValueInfo.text = "\(txn.value) ETH"
        
    }
}

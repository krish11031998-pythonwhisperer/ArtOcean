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
            txnImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            txnImage.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            txnImage.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor)
        ])

        return view
    }()
    
    private lazy var stackView:UIStackView = {
        
        let stack = UIStackView(arrangedSubviews: [txnImageBackground,txnDetails,txnInfoView])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let txnValueInfo:CustomLabel = {
        let label = CustomLabel(text: "", size: 14, weight: .medium, color: .black, numOfLines: 1, adjustFontSize: true, autoLayout: false)
//        label.setContentHuggingPriority(.init(249), for: .horizontal)
//        label.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        return label
    }()
    
    private let txnUser:CustomLabel = {
        let label = CustomLabel(text: "", size: 14, weight: .medium, color: .appGrayColor, numOfLines: 1, adjustFontSize: true, autoLayout: false)
        return label
    }()
    
    private lazy var txnDetails:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [txnValueInfo])
        stack.axis = .vertical
        stack.spacing = 8
        stack.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        stack.setContentHuggingPriority(.init(249), for: .horizontal)
        return stack
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
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected{
            bouncyButtonClick()
            setHighlighted(false, animated: true)
        }
        
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
        resetCell()
        switch txn.type{
            case .receive:
                txnImage.image = .init(named: "arrow-up")?.withTintColor(.appGreenColor)
                txnValueInfo.text = "\(txn.value) ETH"
            case .send:
                txnImage.image = .init(named: "arrow-up-right")?.withTintColor(.red)
                txnValueInfo.text = "\(txn.value) ETH"
            case .buy,.sell:
                if let img = txn.artModel?.metadata?.image{
                    ImageDownloader.shared.fetchImage(urlStr: img) { result in
                        switch result{
                        case .success(let img):
                            DispatchQueue.main.async { [weak self] in
                                self?.txnImage.image = img
                                self?.txnImage.contentMode = .scaleAspectFill
                                self?.txnImage.clipsToBounds = true
                                self?.txnImage.layer.cornerRadius = 8
                            }
                        case .failure(let err):
                            print("(DEBUG) err : ",err.localizedDescription)
                        }
                    }
                    txnImageBackground.layer.cornerRadius = 8
                    txnValueInfo.text = txn.artModel?.title ?? "XXXXX"
                    txnUser.text = "@krishna"
                    txnDetails.addArrangedSubview(txnUser)
                }
        }
        
        txnType.text = txn.type.rawValue.capitalized
        
        timeInfo.text = txn.dayTimes + " days ago"
        
    }
    
    func resetCell(){
        txnImage.image = nil
        txnValueInfo.text = ""
        txnType.text = ""
        timeInfo.text = ""
    }
}

//
//  NFTAttribute.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 19/06/2022.
//

import Foundation
import UIKit

class NFTAttributeView:UIStackView{
    
    private var attributes:[Attribute]?

    
    init(attributes: [Attribute]) {
        self.attributes = attributes
        super.init(frame: .zero)
        self.configStack()
        self.setupStack()
    }
    
    func configStack(){
        self.axis = .vertical
        self.spacing = 8
    }
    
    func setupStack(){
        self.addArrangedSubview(CustomLabel(text: "Attributes", size: 16, weight: .bold, color: .appBlackColor, numOfLines: 1, adjustFontSize: true))
        self.addArrangedSubview(self.stackView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.backgroundColor = .clear
        stack.layer.borderColor = UIColor.appGrayColor.withAlphaComponent(0.15).cgColor
        stack.layer.borderWidth = 1
        stack.layer.cornerRadius = 16
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 16, left: 0, bottom: 16, right: 0)
        
        if let safeAttributes = self.attributes{
            for attribute in safeAttributes{
                stack.addArrangedSubview(self.innerCardBuilder(attribute))
            }
        }
        
        return stack
        
    }()
    
}

//MARK: - Attributes Stack
extension NFTAttributeView{
    func innerCardBuilder(_ attributeData:Attribute) -> UIStackView{
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        
        let trait_type = CustomLabel(text: attributeData.trait_type ?? "no Trait", size: 14, weight: .semibold, color: .appGrayColor, numOfLines: 1, adjustFontSize: false)
        stackView.addArrangedSubview(trait_type)
        
        trait_type.setContentHuggingPriority(.init(rawValue: 249), for: .horizontal)
        trait_type.setContentCompressionResistancePriority(.init(rawValue: 749), for: .horizontal)
        
        if let safeIntValue = attributeData.int_value{
            let value = CustomLabel(text: "\(safeIntValue)" , size: 14, weight: .bold, color: .appBlackColor, numOfLines: 1, adjustFontSize: false)
            stackView.addArrangedSubview(value)
        }else if let safeStringValue = attributeData.str_value{
            let value = CustomLabel(text: safeStringValue , size: 14, weight: .bold, color: .appBlackColor, numOfLines: 1, adjustFontSize: false)
            stackView.addArrangedSubview(value)
        }
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return stackView
    }
}

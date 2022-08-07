//
//  NFTAttribute.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 19/06/2022.
//

import Foundation
import UIKit

class NFTAttributeCell:UIView{
	
	private var trait_type:UILabel?
	private var value_label:UILabel?
	
	
//	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
	init(attribute:Attribute) {
		super.init(frame: .zero)
		setupContentCell()
		configureCell(with: attribute)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupContentCell(){
		let view = innerCardBuilder()
		addViewAndSetConstraints(view, edgeInsets: .init(vertical: 8, horizontal: 16))
		backgroundColor = .clear
	}
	
	func innerCardBuilder() -> UIStackView{
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.spacing = 8
		
		trait_type = CustomLabel(text: "", size: 14, weight: .medium, color: .appGrayColor, numOfLines: 1, adjustFontSize: false)
		stackView.addArrangedSubview(trait_type!)
		
		stackView.addArrangedSubview(.spacer())
		
		value_label = CustomLabel(text: "" , size: 14, weight: .bold, color: .appBlackColor, numOfLines: 1, adjustFontSize: false)
		stackView.addArrangedSubview(value_label!)
		
	
		stackView.heightAnchor.constraint(equalToConstant: 24).isActive = true
			
		return stackView
	}
	
	func configureCell(with model: Attribute) {
		
		if let type = model.trait_type{
			trait_type?.text = type
		}
		
		if let value = model.Value{
			value_label?.text = value
		}
	}
	
}

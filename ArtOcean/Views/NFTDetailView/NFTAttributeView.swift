//
//  NFTAttributeView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 10/07/2022.
//

import Foundation
import UIKit

class NFTAttributeView:ConfigurableCell {

//MARK: - Properties
	
	private lazy var stackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 0
		stack.bordered(cornerRadius: 20, borderWidth: 1.25, borderColor: UIColor.appBlackColor.withAlphaComponent(0.25))
		return stack
	}()

	
//MARK: - Constructors
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addViewAndSetConstraints(stackView, edgeInsets: .init(vertical: .zero, horizontal: 16))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
//MARK: - Exposed Methods
	
	func configureCell(with model: [Attribute]) {
		selectionStyle = .none
		backgroundColor = .clear
		isUserInteractionEnabled = false
		if !stackView.arrangedSubviews.isEmpty {
			stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
		}
		model.forEach { stackView.addArrangedSubview(NFTAttributeCell(attribute: $0)) }
	}
	
	
}

//
//  NFTArtIntroductionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 02/07/2022.
//

import Foundation
import UIKit

class NFTArtIntroduction:ConfigurableCell{
	
	private var interactiveView:NFTArtInteractiveInfoView?
	
	private var titleView:UILabel?
	
	private var descriptionView:UILabel?
	
	private lazy var titleDescriptionView:UIStackView = {
		let stack = UIStackView(arrangedSubviews: [titleView,descriptionView].compactMap{ $0 })
		stack.axis = .vertical
		stack.spacing = 8
		
		descriptionView?.setContentHuggingPriority(.init(249), for: .vertical)
		descriptionView?.setContentCompressionResistancePriority(.init(749), for: .vertical)
				
		return stack
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configureCell(with model: NFTModel) {
		titleView = CustomLabel(text: model.Title, size: 18, weight: .bold, color: .appBlackColor, numOfLines: 1, adjustFontSize: true)
		descriptionView = CustomLabel(text: model.Description, size: 14, weight: .medium, color: .appGrayColor, numOfLines: 3, adjustFontSize: false)
		interactiveView = .init(nft: model)
		backgroundColor = .clear
		buildContentView()
	}
	
	func buildContentView(){
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 12
		
		contentView.subviews.forEach { $0.removeFromSuperview() } 
		
		[interactiveView, titleDescriptionView].compactMap{ $0 }.forEach { stackView.addArrangedSubview($0) }
		
		contentView.addSubview(stackView)
		contentView.setContraintsToChild(stackView,edgeInsets: .init(top: 0, left: 16, bottom: 0, right: -16))
	}
	
}

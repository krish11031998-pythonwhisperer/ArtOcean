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
	
	private let titleView: UILabel = .init()
	private let descriptionView: UILabel = .init()
	
	private lazy var titleDescriptionView:UIStackView = {
		let stack = UIStackView(arrangedSubviews: [titleView,descriptionView].compactMap{ $0 })
		stack.axis = .vertical
		stack.spacing = 8
		
		return stack
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configureCell(with model: NFTModel) {
		model.Title.replace().heading4().renderInto(target: titleView)
		descriptionView.numberOfLines = 0
		model.Description.body2Medium(color: .subtitleColor).renderInto(target: descriptionView)
		interactiveView = .init()
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
		contentView.setConstraintsToChild(stackView,edgeInsets: .init(top: 0, left: 16, bottom: 0, right: 16))
	}
	
}

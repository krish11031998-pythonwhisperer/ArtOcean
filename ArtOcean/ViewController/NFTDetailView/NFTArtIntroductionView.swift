//
//  NFTArtIntroductionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 02/07/2022.
//

import Foundation
import UIKit

struct NFTArtSectionData: ActionProvider {
	let nft: NFTModel
	var action: Callback?
}

class NFTArtIntroduction: UIView{
	
	private var interactiveView:NFTArtInteractiveInfoView?
	
	private let titleView: UILabel = .init()
	private let descriptionView: UILabel = .init()
	
	private lazy var titleDescriptionView:UIStackView = {
		let stack = UIStackView(arrangedSubviews: [titleView,descriptionView].compactMap{ $0 })
		descriptionView.numberOfLines = 1
		stack.axis = .vertical
		stack.spacing = 8
		
		return stack
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		descriptionView.numberOfLines = 1
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func buildContentView(){
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 0
		
		subviews.forEach { $0.removeFromSuperview() }
		
		[interactiveView, titleView,descriptionView].compactMap{ $0 }.forEach {
			stackView.addArrangedSubViewsWithSpacing(view: $0, spacing: $0 === interactiveView ? 20 : 8)
		}
		
		addSubview(stackView)
		setConstraintsToChild(stackView,edgeInsets: .init(vertical: 10, horizontal: 16))
	}
	
	public func resizeDescription() {
		print("(DEBUG)",descriptionView.numberOfLines)
		descriptionView.numberOfLines = descriptionView.numberOfLines == 1 ? 0 : 1
	}
	
}


//MARK: Configurable

extension NFTArtIntroduction: Configurable {
	func configureCell(with model: NFTArtSectionData) {
		model.nft.Title.replace().heading4().renderInto(target: titleView)
		model.nft.Description.body2Medium(color: .subtitleColor).renderInto(target: descriptionView)
		interactiveView = .init()
		backgroundColor = .clear
		buildContentView()
	}
	
}

//
//  CustomInfoButton.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 09/08/2022.
//

import Foundation
import UIKit

struct CustomInfoButtonModel {
	
	let leadingImage: UIImage?
	let title: RenderableText?
	let subTitle: RenderableText?
	let infoTitle: RenderableText?
	let infoSubTitle: RenderableText?
	let trailingImage: UIImage?
	
	init(leadingImg: UIImage? = nil,
		 title: RenderableText? = nil,
		 subTitle: RenderableText? = nil,
		 infoTitle: RenderableText? = nil,
		 infoSubTitle: RenderableText? = nil,
		 trailingImage: UIImage? = nil
	) {
		self.leadingImage = leadingImg
		self.title = title
		self.subTitle = subTitle
		self.infoTitle = infoTitle
		self.infoSubTitle = infoSubTitle
		self.trailingImage = trailingImage
	}
}

class CustomInfoButton: UIButton {

//MARK: - Properties
	
	private var topLeadingLabel: UILabel = { .init() }()
	private var bottomLeadingLabel: UILabel = { .init() }()
	private var topTrailingLabel: UILabel = { .init() }()
	private var bottomTrailingLabel: UILabel = { .init() }()
	private var leadingImageView: UIImageView = {
		let imgView: UIImageView = .init()
		imgView.contentMode = .scaleAspectFit
		return imgView
	}()
	private var trailingImageView: UIImageView = {
		let imgView: UIImageView = .init()
		imgView.contentMode = .scaleAspectFit
		return imgView
	}()

	public var handler: (() -> Void)?
	
	public var leadingImage: UIImage? {
		get { leadingImageView.image }
		set {
			leadingImageView.image = newValue
			leadingImageView.isHidden = newValue == nil
		}
	}
	
	public var trailingImage: UIImage? {
		get { trailingImageView.image }
		set {
			trailingImageView.image = newValue
			trailingImageView.isHidden = newValue == nil
		}
	}
	
	public var titleText: RenderableText? {
		get { topLeadingLabel.attributedText }
		set {
			newValue?.renderInto(target: topLeadingLabel)
			topLeadingLabel.isHighlighted = newValue == nil
		}
	}
	
	public var subTitleText: RenderableText? {
		get { bottomLeadingLabel.attributedText }
		set {
			newValue?.renderInto(target: bottomLeadingLabel)
			bottomLeadingLabel.isHighlighted = newValue == nil
		}
	}
	
	public var infoTitle: RenderableText? {
		get { topTrailingLabel.attributedText }
		set {
			newValue?.renderInto(target: topTrailingLabel)
			topTrailingLabel.isHighlighted = newValue == nil
		}
	}
	
	public var infoSubTitle: RenderableText? {
		get { bottomTrailingLabel.attributedText }
		set {
			newValue?.renderInto(target: bottomTrailingLabel)
			bottomTrailingLabel.isHighlighted = newValue == nil
		}
	}
	
//MARK: - Constructors
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		buildButton()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

//MARK: - Protected Methods
	
	private func buildButton() {
		let mainStack = mainStackBuilder()
		addSubview(mainStack)
		setContraintsToChild(mainStack, edgeInsets: .zero)
		addTarget(self, action: #selector(handleTap), for: .touchUpInside)
	}
	
	private func rebuildButton() {
		removeAllSubViews()
		buildButton()
	}
	
	@objc func handleTap() {
		bouncyButtonClick { [weak self] in
			self?.handler?()
		}
	}
	private func leadingStack() -> UIStackView? {
		let stack: UIStackView = .VStack(spacing: 0)
		let views: [UIView] = [topLeadingLabel,bottomLeadingLabel]
		views.forEach { stack.addArrangedSubViewsWithSpacing(view: $0, spacing: 8) }
		return stack
	}
	
	private func trailingStack() -> UIStackView? {
		let stack: UIStackView = .VStack(spacing: 0)
		let views: [UIView] = [topTrailingLabel,bottomTrailingLabel]
		views.forEach { stack.addArrangedSubViewsWithSpacing(view: $0, spacing: 8) }
		return stack
	}
	
	private func mainStackBuilder() -> UIStackView {
		let mainStack: UIStackView = .HStack(spacing: 16,aligmment: .center)
		mainStack.isUserInteractionEnabled = false
		let views: [UIView] = [leadingImageView,leadingStack(),.spacer(),trailingStack(),trailingImageView].compactMap { $0 }
		leadingImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 32).isActive = true
		leadingImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 32).isActive = true
		trailingImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 32).isActive = true
		trailingImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 32).isActive = true
		views.forEach(mainStack.addArrangedSubview)
		return mainStack
	}
	
	
//MARK: - Exposed Methods
}


class CustomInfoButtonCell: ConfigurableCell {
	
	private lazy var button: CustomInfoButton = { .init() }()
	
	func configureCell(with model: CustomInfoButtonModel) {
		
		contentView.addSubview(button)
		contentView.setContraintsToChild(button, edgeInsets: .init(vertical: 10, horizontal: 16))
		
		button.isUserInteractionEnabled = false
		button.leadingImage = model.leadingImage
		button.titleText = model.title
		button.subTitleText = model.subTitle
		button.infoTitle = model.infoTitle
		button.infoSubTitle = model.infoSubTitle
		button.trailingImage = model.trailingImage
		backgroundColor = .clear

	}
	
}

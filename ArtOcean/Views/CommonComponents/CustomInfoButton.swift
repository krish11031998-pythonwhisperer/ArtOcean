//
//  CustomInfoButton.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 09/08/2022.
//

import Foundation
import UIKit

struct CustomInfoButtonModel: ActionProvider {
	
	let leadingImage: UIImage?
	let title: RenderableText?
	let subTitle: RenderableText?
	let infoTitle: RenderableText?
	let infoSubTitle: RenderableText?
	let trailingImage: UIImage?
	let leadingImageUrl: String?
	let trailingImageUrl: String?
	let imgSize: CGSize
	let style: ImageStyle
	var action: Callback?
	
	init(leadingImg: UIImage? = nil,
		 title: RenderableText? = nil,
		 subTitle: RenderableText? = nil,
		 infoTitle: RenderableText? = nil,
		 infoSubTitle: RenderableText? = nil,
		 trailingImage: UIImage? = nil,
		 leadingImageUrl: String? = nil,
		 trailingImageUrl: String? = nil,
		 style: ImageStyle = .original,
		 imgSize: CGSize = .squared(32),
		 action: Callback? = nil
	) {
		self.leadingImage = leadingImg
		self.title = title
		self.subTitle = subTitle
		self.infoTitle = infoTitle
		self.infoSubTitle = infoSubTitle
		self.trailingImage = trailingImage
		self.leadingImageUrl = leadingImageUrl
		self.trailingImageUrl = trailingImageUrl
		self.style = style
		self.imgSize = imgSize
		self.action = action
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
		imgView.contentMode = .scaleAspectFill
		imgView.clipsToBounds = true
		return imgView
	}()
	private var trailingImageView: UIImageView = {
		let imgView: UIImageView = .init()
		imgView.contentMode = .scaleAspectFill
		imgView.clipsToBounds = true
		return imgView
	}()

	public var handler: (() -> Void)?
	
	public var leadingImage: UIImage? {
		get { leadingImageView.image }
		set {
			leadingImageView.image = newValue
			leadingImageView.isHidden = newValue == nil
			if leadingImageView.superview == nil && newValue != nil {
				mainStack.insertArrangedSubview(leadingImageView, at: 0)
			}
		}
	}
	
	public var trailingImage: UIImage? {
		get { trailingImageView.image }
		set {
			trailingImageView.image = newValue
			trailingImageView.isHidden = newValue == nil
			if trailingImageView.superview == nil && newValue != nil {
				mainStack.addArrangedSubview(trailingImageView)
			}
		}
	}
	
	public var titleText: RenderableText? {
		get { topLeadingLabel.attributedText }
		set {
			newValue?.renderInto(target: topLeadingLabel)
//			topLeadingLabel.isHighlighted = newValue == nil
		}
	}
	
	public var subTitleText: RenderableText? {
		get { bottomLeadingLabel.attributedText }
		set {
			newValue?.renderInto(target: bottomLeadingLabel)
//			bottomLeadingLabel.isHighlighted = newValue == nil
		}
	}
	
	public var infoTitle: RenderableText? {
		get { topTrailingLabel.attributedText }
		set {
			newValue?.renderInto(target: topTrailingLabel)
//			topTrailingLabel.isHighlighted = newValue == nil
		}
	}
	
	public var infoSubTitle: RenderableText? {
		get { bottomTrailingLabel.attributedText }
		set {
			newValue?.renderInto(target: bottomTrailingLabel)
//			bottomTrailingLabel.isHighlighted = newValue == nil
		}
	}
	
	private lazy var mainStack: UIStackView = { .HStack(spacing: 16,aligmment: .center) }()
	
//MARK: - Constructors
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		buildButton()
		setImageSize()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

//MARK: - Protected Methods
	
	private func buildButton() {
		mainStackBuilder()
		addSubview(mainStack)
		setConstraintsToChild(mainStack, edgeInsets: .zero)
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
		let stack: UIStackView = .VStack(spacing: 8)
		let views: [UIView] = [topLeadingLabel,bottomLeadingLabel]
		views.forEach(stack.addArrangedSubview)
		return stack
	}
	
	private func trailingStack() -> UIStackView? {
		let stack: UIStackView = .VStack(spacing: 8)
		let views: [UIView] = [topTrailingLabel,bottomTrailingLabel]
		bottomTrailingLabel.textAlignment = .right
		topTrailingLabel.textAlignment = .right
		views.forEach(stack.addArrangedSubview)
		return stack
	}
	
	private func mainStackBuilder() {
		mainStack.isUserInteractionEnabled = false
		var views: [UIView] = []
		
		if let validLeadingStack = leadingStack() {
			views.append(validLeadingStack)
		}
		
		if let validTrailingStack = trailingStack() {
			views.append(.spacer())
			views.append(validTrailingStack)
		}
		
		if leadingImage != nil { views.insert(leadingImageView, at: 0) }
		if trailingImage != nil { views.append(trailingImageView) }
		views.forEach(mainStack.addArrangedSubview)
		mainStack.accessibilityIdentifier = "MainStack"
	}
	
	public func setImageSize(size: CGSize = .squared(32)) {
		leadingImageView.removeAllConstraints()
		trailingImageView.removeAllConstraints()
		leadingImageView.widthAnchor.constraint(lessThanOrEqualToConstant: size.width).isActive = true
		leadingImageView.heightAnchor.constraint(lessThanOrEqualToConstant: size.height).isActive = true
		trailingImageView.widthAnchor.constraint(lessThanOrEqualToConstant: size.width).isActive = true
		trailingImageView.heightAnchor.constraint(lessThanOrEqualToConstant: size.height).isActive = true
	}
	
	public func loadImageForButton(leading: String? = nil, trailing: String? = nil, style: ImageStyle = .original) {
		
		if let validLeadingImg = leading {
			UIImage.loadImage(url: validLeadingImg, for: leadingImageView, at: \.image)
		}
		
		if let validTrailingImg = trailing {
			UIImage.loadImage(url: validTrailingImg, for: trailingImageView, at: \.image)
		}
		
	}
	
	public func updateUIButton(_ buttonInfo: CustomInfoButtonModel) {
		titleText = buttonInfo.title
		subTitleText = buttonInfo.subTitle
		infoTitle = buttonInfo.infoTitle
		infoSubTitle = buttonInfo.infoSubTitle
		
		if let _ =  buttonInfo.leadingImageUrl {
			leadingImage = .loadingBackgroundImage.roundedImage(cornerRadius: 8)
		} else if let leadingImage = buttonInfo.leadingImage {
			self.leadingImage = leadingImage
		}
		
		if let _ =  buttonInfo.trailingImageUrl {
			trailingImage = .loadingBackgroundImage.roundedImage(cornerRadius: 8)
		} else if let trailingImage = buttonInfo.trailingImage {
			self.trailingImage = trailingImage
		}
		

		self.leadingImageView.cornerRadius = buttonInfo.style.cornerRadius
		self.trailingImageView.cornerRadius = buttonInfo.style.cornerRadius
		
		setImageSize(size: buttonInfo.imgSize)
		
		loadImageForButton(leading: buttonInfo.leadingImageUrl, trailing: buttonInfo.trailingImageUrl, style: buttonInfo.style)
		
	}
	
//MARK: - Exposed Methods
}

//MARK: - CustomInfoButtonTableCell

class CustomInfoButtonCell: ConfigurableCell {
	
	private lazy var button: CustomInfoButton = { .init() }()
	
	func configureCell(with model: CustomInfoButtonModel) {
		
		contentView.addSubview(button)
		contentView.setConstraintsToChild(button, edgeInsets: .init(vertical: 10, horizontal: 16))
		
		button.isUserInteractionEnabled = false
		button.updateUIButton(model)
		backgroundColor = .clear

	}
	
}

class CustomInfoButtonCollectionCell: ConfigurableCollectionCell {
	
	private lazy var button: CustomInfoButton = { .init() }()
	
	func configureCell(with model: CustomInfoButtonModel) {
		contentView.addSubview(button)
		contentView.setConstraintsToChild(button, edgeInsets: .init(vertical: 10, horizontal: 16))
		
		button.isUserInteractionEnabled = false
		button.updateUIButton(model)
		backgroundColor = .clear
	}
	
}

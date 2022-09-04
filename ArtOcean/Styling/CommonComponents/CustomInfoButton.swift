//
//  CustomInfoButton.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 09/08/2022.
//

import Foundation
import UIKit

extension UIImageView {
	
	func updateImage(url: String? = nil, img: UIImage? = nil, cornerRadius: CGFloat) {
		image = nil
		if let validImage = img {
			image = validImage
		} else if let validUrl = url {
			image = .loadingBackgroundImage
			UIImage.loadImage(url: validUrl, for: self, at: \.image)
		}
		self.cornerRadius = cornerRadius
	}
	
}

extension UIStackView {
	
	func setPaddingAfterViewAt(idx: Int, with padding: CGFloat) {
		guard arrangedSubviews.count > idx && idx >= 0 else { return }
		setCustomSpacing(padding, after: arrangedSubviews[idx])
	}
	
}

struct CustomInfoButtonModel: ActionProvider {
	
	let leadingImage: UIImage?
	let title: RenderableText?
	let subTitle: RenderableText?
	let infoTitle: RenderableText?
	let infoSubTitle: RenderableText?
	let trailingImage: UIImage?
	let leadingImageUrl: String?
	let trailingImageUrl: String?
	let leadingImgSize: CGSize
	let trailingImgSize: CGSize
	let style: ImageStyle
	let edges: UIEdgeInsets
	var action: Callback?
	
//	let includeSeperator: Bool
	
	init(leadingImg: UIImage? = nil,
		 title: RenderableText? = nil,
		 subTitle: RenderableText? = nil,
		 infoTitle: RenderableText? = nil,
		 infoSubTitle: RenderableText? = nil,
		 trailingImage: UIImage? = nil,
		 leadingImageUrl: String? = nil,
		 trailingImageUrl: String? = nil,
		 style: ImageStyle = .original,
		 leadingImgSize: CGSize = .smallestSqaure,
		 trailingImgSize: CGSize = .smallestSqaure,
		 edges: UIEdgeInsets = .init(vertical: 10, horizontal: 16),
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
		self.leadingImgSize = leadingImgSize
		self.trailingImgSize = trailingImgSize
		self.edges = edges
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
			topLeadingLabel.isHidden = newValue == nil
		}
	}
	
	public var subTitleText: RenderableText? {
		get { bottomLeadingLabel.attributedText }
		set {
			newValue?.renderInto(target: bottomLeadingLabel)
			bottomLeadingLabel.isHidden = newValue == nil
		}
	}
	
	public var infoTitle: RenderableText? {
		get { topTrailingLabel.attributedText }
		set {
			newValue?.renderInto(target: topTrailingLabel)
			topTrailingLabel.isHidden = newValue == nil
		}
	}
	
	public var infoSubTitle: RenderableText? {
		get { bottomTrailingLabel.attributedText }
		set {
			newValue?.renderInto(target: bottomTrailingLabel)
			bottomTrailingLabel.isHidden = newValue == nil
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
		
		views.insert(leadingImageView, at: 0)
		views.append(trailingImageView)
		views.forEach(mainStack.addArrangedSubview)
		mainStack.accessibilityIdentifier = "MainStack"
	}
	
	public func setImageSize(size: CGSize = .squared(32)) {
		
		leadingImageView.setFrameConstraints(size: size)
		trailingImageView.setFrameConstraints(size: size)
		
		leadingImageView.isHidden = leadingImage == nil
		trailingImageView.isHidden = trailingImage == nil
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
		
		leadingImageView.updateImage(url: buttonInfo.leadingImageUrl, img: buttonInfo.leadingImage, cornerRadius: buttonInfo.style.cornerRadius)

		trailingImageView.updateImage(url: buttonInfo.trailingImageUrl, img: buttonInfo.trailingImage, cornerRadius: buttonInfo.style.cornerRadius)

		leadingImageView.setFrameConstraints(size: buttonInfo.leadingImgSize)
		trailingImageView.setFrameConstraints(size: buttonInfo.trailingImgSize)
		
		leadingImageView.isHidden = leadingImage == nil
		trailingImageView.isHidden = trailingImage == nil
	}
	
//MARK: - Exposed Methods
}

//MARK: - CustomInfoButtonTableCell

class CustomInfoButtonCell: ConfigurableCell {
	
	private lazy var button: CustomInfoButton = { .init() }()
	
	func configureCell(with model: CustomInfoButtonModel) {
		
		contentView.removeAllSubViews()
		
		let line: UIView = .init()
		line.backgroundColor = interface == .light ? .greyscale200 : .appIndigoFadeLight
		line.setHeightWithPriority(1)

		let view: UIStackView = .VStack(views: [button, line], spacing: 18)
		contentView.addSubview(view)
		contentView.setConstraintsToChild(view, edgeInsets: model.edges)
		
		button.isUserInteractionEnabled = false
		button.updateUIButton(model)
		backgroundColor = .clear

	}
	
}

class CustomInfoButtonCollectionCell: ConfigurableCollectionCell {
	
	private lazy var button: CustomInfoButton = { .init() }()
	
	func configureCell(with model: CustomInfoButtonModel) {
		contentView.addSubview(button)
		contentView.setConstraintsToChild(button, edgeInsets: model.edges)
		
		button.isUserInteractionEnabled = false
		button.updateUIButton(model)
		backgroundColor = .clear
	}
	
}

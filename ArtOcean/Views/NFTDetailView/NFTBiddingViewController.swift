//
//  NFTBIdViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 21/08/2022.
//

import Foundation
import UIKit

class NFTBiddingViewController: UIViewController {
	
	private var nftArt: NFTModel?

	private lazy var priceLabel: UILabel = { .init() }()
	private lazy var balanceLabel: UILabel = { .init() }()
	private lazy var accordian: AccordianStackView = { .init() }()
	private lazy var scrollStackView: ScrollableStackView = {
		let view = ScrollableStackView()
		view.aligment = .center
		view.spacing = 10
		return view
	}()
	
	private lazy var plusButton: CustomImageButton = {
		.init(name: .plus, addBG: false, tintColor: .appBlackColor, bgColor: .clear)
	}()
	
	private lazy var minusButton: CustomImageButton = {
		.init(name: .minus, addBG: false, tintColor: .appBlackColor, bgColor: .clear)
	}()
	
	private lazy var imageView: CustomImageView = {
		let imageView: CustomImageView = .init(url: nftArt?.metadata?.image, cornerRadius: 16)
		imageView.setHeightWithPriority(preferredContentSize.height * 0.15,priority: .required)
		imageView.setWidthWithPriority(preferredContentSize.width * 0.25,priority: .required)
		return imageView
	}()
	
	private lazy var headerInfoLabel: HeaderCaptionLabel = { .init() }()
	
	init(nftArtModel: NFTModel?) {
		self.nftArt = nftArtModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupNavBar() {
		let title: UILabel = .init()
		let closeButton: CustomImageButton = .closeButton { [weak self] in
			self?.presentingViewController?.dismiss(animated: true)
		}
		
		"Place A Bid".styled(font: .bold, color: .appBlackColor, size: 22.5).renderInto(target: title)
		
		navigationItem.leftBarButtonItem = .init(customView: title)
		navigationItem.rightBarButtonItem = .init(customView: closeButton)
		setupStatusBar(color: nil)
		navigationController?.additionalSafeAreaInsets.top = 20
	}
	
	override func viewDidLoad() {
		view.backgroundColor = .white
		view.cornerRadius(32, at: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
		preferredContentSize = .init(width: .totalWidth, height: .totalHeight * 0.8)
	
		view.addSubview(scrollStackView)
		view.setSafeAreaConstraintsToChild(scrollStackView, edgeInsets: .zero)

		setupNavBar()
		setupNFTDetailSection()
		attributes()
		setupPriceIndicator()
		placeBidButton()
	}
	
	private func setupNFTDetailSection() {
		
		guard let validNFT = nftArt else { return }
		
		let title: RenderableText = validNFT.Title.styled(font: .medium, color: .appBlackColor, size: 20)
		let subTitle: RenderableText = (validNFT.id?.tokenId ?? "").styled(font: .regular, color: .appGrayColor, size: 13)
		headerInfoLabel.configureLabel(title: title, subTitle: subTitle)
		let stack: UIStackView = .HStack(views:[imageView, headerInfoLabel], spacing: 8,aligmment: .top)

		scrollStackView.addArrangedSubview(stack, withWidthFactor: 2)
		scrollStackView.setCustomSpacing(25, after: stack)
	}
	
	private func  setupPriceIndicator() {
		let stack: UIStackView = .HStack(spacing: 8,aligmment: .fill)

		"0.038 ETH".styled(font: .bold, color: .appBlackColor, size: 24).renderInto(target: priceLabel)

		let img = UIImageView(image: UIImage.Catalogue.eth.image.resized(.init(width: 12, height: 20)))
		img.contentMode = .scaleAspectFit
		[plusButton,.spacer(width: 16),img,priceLabel,.spacer(width: 16),minusButton].forEach { stack.addArrangedSubview($0) }

		stack.setHeightWithPriority(40)
		let borderedView = stack.marginedBorderedCard(borderColor: .appPurpleColor.withAlphaComponent(0.35))

		"Balance: {} ETH".replace(val: "0.045").styled(font: .medium, color: .appGrayColor, size: 14).renderInto(target: balanceLabel)

		let holderStack: UIStackView = .VStack(views: [borderedView, balanceLabel], spacing: 8, aligmment: .center)

		scrollStackView.addArrangedSubview(holderStack, withWidthFactor: 2)
		scrollStackView.setCustomSpacing(25, after: holderStack)
	}

	private func attributes() {

		guard let validAttributes = nftArt?.metadata?.attributes else { return }

		let labels: [UIView] = validAttributes.filter { $0.trait_type != nil && $0.Value != nil }.map(\.attributeBlob)
		accordian.configureAccordian(labels, innerSize: .init(width: preferredContentSize.width - 32, height: .zero), with: 10)
		scrollStackView.addArrangedSubview(accordian, withWidthFactor: 2)
		accordian.hideElement(2)
		scrollStackView.setCustomSpacing(25, after: accordian)
	}

	private func placeBidButton() {
		let button = CustomLabelButton(title: "Place a bid", font: .medium, size: 14, color: .white, backgroundColor: .appBlueColor, handler: nil)
		scrollStackView.addArrangedSubview(button, withWidthFactor: 2)
		let bottomInset: CGFloat = UIWindow.safeAreaInset.bottom + scrollStackView.scrollViewInset.vertical
		scrollStackView.addArrangedSubview(.solidColorView(color: .clear, size: .init(width: .totalWidth.half(), height: 200)), withWidthFactor: 2)
		button.setHeightWithPriority(40, priority: .required)
	}
	
	@objc private func onTap() {
		presentingViewController?.dismiss(animated: true)
	}
	
}

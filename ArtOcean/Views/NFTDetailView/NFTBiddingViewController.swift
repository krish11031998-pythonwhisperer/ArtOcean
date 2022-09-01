//
//  NFTBIdViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 21/08/2022.
//

import Foundation
import UIKit

extension UIView {
	
	struct CustomWrapperConfigurableModel: ActionProvider {
		var innerView: UIView
		var isUserInteractionEnabled: Bool
		var edges: UIEdgeInsets
		var action: Callback?
		
		init(innerView: UIView, isUserInteractionEnabled: Bool = false, edges: UIEdgeInsets = .init(by: 10), action: Callback?) {
			self.innerView = innerView
			self.isUserInteractionEnabled = isUserInteractionEnabled
			self.edges = edges
			self.action = action
		}
	}

	class CustomWrapperConfigurableCell: ConfigurableCell {
		func configureCell(with model: CustomWrapperConfigurableModel) {
			selectionStyle = .none
			backgroundColor = .clear
			contentView.removeAllSubViews()
			model.innerView.isUserInteractionEnabled = model.isUserInteractionEnabled
			contentView.addSubview(model.innerView)
			contentView.setConstraintsToChild(model.innerView, edgeInsets: model.edges)
		}
	}
	
	
	func TableRowBuilder(isUserInteractionEnabled interaction: Bool = false, edges: UIEdgeInsets = .init(by: 10), action: Callback? = nil) -> CellProvider {
		TableRow<CustomWrapperConfigurableCell>(.init(innerView: self,
													  isUserInteractionEnabled: interaction,
													  edges: edges,
													  action: action))
	}
	
	
}



class NFTBiddingViewController: UIViewController {
	
	private var nftArt: NFTModel?

	private lazy var priceLabel: UILabel = { .init() }()
	private lazy var balanceLabel: UILabel = { .init() }()
	private lazy var accordian: AccordianStackView = { .init(handler: nil) }()
	private lazy var scrollStackView: ScrollableStackView = {
		let view = ScrollableStackView()
		view.aligment = .center
		view.spacing = 25
		return view
	}()
	
	private let edges: UIEdgeInsets = .init(vertical: 10, horizontal: 16)
	
	private var bottomInset: CGFloat { (UIWindow.key?.safeAreaInsets.bottom ?? .zero) + 25 }
	
	private var tableView: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		table.separatorStyle = .none
		table.backgroundColor = .clear
		table.isScrollEnabled = false
		table.rowHeight = UITableView.automaticDimension
		return table
	}()
	
	private lazy var plusButton: CustomImageButton = {
		.init(name: .plus, addBG: false, tintColor: .surfaceBackgroundInverse, bgColor: .clear)
	}()
	
	private lazy var minusButton: CustomImageButton = {
		.init(name: .minus, addBG: false, tintColor: .surfaceBackgroundInverse, bgColor: .clear)
	}()
	
	private lazy var imageView: CustomImageView = {
		let imageView: CustomImageView = .init(url: nftArt?.metadata?.image, cornerRadius: 16)
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
		
		"Place A Bid".heading3().renderInto(target: title)
		
		navigationItem.leftBarButtonItem = .init(customView: title)
		navigationItem.rightBarButtonItem = .init(customView: closeButton)
		setupStatusBar(color: nil)
		navigationController?.additionalSafeAreaInsets.top = 20
	}
	
	override func viewDidLoad() {
		view.backgroundColor = .surfaceBackground
		view.cornerRadius(32, at: .top)
		
		setupNavBar()
		view.addViewAndSetConstraints(tableView, edgeInsets: .zero)
		tableView.reload(with: buildDataSource())
		
		preferredContentSize = .init(width: .totalWidth, height: tableView.contentSize.height + 2 * bottomInset)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.rowHeight = UITableView.automaticDimension
	}
	
	private func buildDataSource() -> TableViewDataSource {
		.init(section: [nftDetailSection, priceIndicator, placeBidButton].compactMap {$0})
	}
	
	private func setupNFTDetailSection() {
		
		guard let validNFT = nftArt else { return }
		
		let title: RenderableText = validNFT.Title.heading3()
		let subTitle: RenderableText = (validNFT.id?.tokenId ?? "").body2Regular()
		headerInfoLabel.configureLabel(title: title, subTitle: subTitle)
		let stack: UIStackView = .HStack(views:[imageView, headerInfoLabel], spacing: 8,aligmment: .top)
		
		imageView.setFrameConstraints(size: .squared(75))

		scrollStackView.addArrangedSubview(stack, withWidthFactor: 2)
	}
	
	private var nftDetailSection: TableSection? {
		
		guard let validNFT = nftArt else { return nil }
		
		let title: RenderableText = validNFT.Title.replace(val: "XXXX").heading3()
		let subTitle: RenderableText = (validNFT.id?.tokenId ?? "").body2Regular(color: .subtitleColor)
		headerInfoLabel.configureLabel(title: title, subTitle: subTitle)
		let stack: UIStackView = .HStack(views:[imageView, headerInfoLabel], spacing: 8,aligmment: .top)
		
		imageView.setFrameConstraints(size: .squared(75))
		
		return TableSection(rows: [stack.TableRowBuilder(edges: edges)])
	}
	
	private var priceIndicator: TableSection? {
		let stack: UIStackView = .HStack(spacing: 8,aligmment: .fill)

		"0.038 ETH".heading2().renderInto(target: priceLabel)
		"Balance: {} ETH".replace(val: "0.045").body2Medium(color: .subtitleColor).renderInto(target: balanceLabel)
		
		let img = UIImageView(image: UIImage.Catalogue.eth.image.resized(.init(width: 12, height: 20)))
		img.contentMode = .scaleAspectFit
		
		[plusButton,.spacer(width: 16),img,priceLabel,.spacer(width: 16),minusButton].forEach { stack.addArrangedSubview($0) }
		stack.setHeightWithPriority(40)
		let borderedView = stack.marginedBorderedCard(borderColor: .appPurpleColor.withAlphaComponent(0.35))
		let holderStack: UIStackView = .VStack(views: [borderedView, balanceLabel], spacing: 8, aligmment: .center)

		return .init(rows: [holderStack.TableRowBuilder(edges: edges)])
	}

//	private var attributes: TableSection? {
//
//		guard let validAttributes = nftArt?.metadata?.attributes else { return nil }
//
//		let labels: [UIView] = validAttributes.filter { $0.trait_type != nil && $0.Value != nil }.map(\.attributeBlob)
//		accordian.configureAccordian(labels, innerSize: .init(width: preferredContentSize.width - 32, height: .zero), with: 10)
//		return .init(rows: [accordian.TableRowBuilder(edges: edges, action: {
//			self.accordian.handleTap()
//		})])
//	}
	
	private var placeBidButton: TableSection? {
		let button = CustomLabelButton(title: "Place a bid", font: .medium, size: 14, color: .white, backgroundColor: .appBlueColor, handler: nil)
		button.setHeightWithPriority(40, priority: .required)
		return .init(rows: [button.TableRowBuilder(edges: edges)])
	}
	
	@objc private func onTap() {
		presentingViewController?.dismiss(animated: true)
	}
	
}

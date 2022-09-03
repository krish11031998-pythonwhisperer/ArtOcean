//
//  ProfileViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

extension NFTArtOffer {
	
	var offerCell: CellProvider { return TableRow<CustomInfoButtonCell>(.init(self, withArtImage: true)) }
}

class ProfileViewController: UIViewController {
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.backgroundColor = UIColor.clear
		tableView.separatorStyle = .none
		return tableView
	}()
	
	private lazy var profileHeaderView: UIView = {
		let headerView = ProfileHeaderView(frame: .init(origin: .zero, size: .init(width: .totalWidth ,height: 300)))
		headerView.delegate = self
		return headerView
	}()

	private lazy var backdropImage: UIImageView = {
		let imageView = UIImageView(frame: .init(origin: .zero, size: .init(width: .totalWidth, height: 200)))
		imageView.updateImageView(url: "https://gutterart.blob.core.windows.net/metadata/image/3.jpeg")
		imageView.blurGradientBackDrop(size: .init(width: .totalWidth, height: 200))
		return imageView
	}()
	
	private var tabs: [SlideSelectorItem] { [NFTArtOfferSection.selectorItem, NFTArtSection.selectorItem].compactMap {$0} }
	
	private var selectedTab: String? = nil {
		didSet { tableView.reload(with: buildDataSource()) }
	}
	
	private lazy var segmentedControl: UIView = {
		let slider = SliderSelector(tabs: tabs)
		slider.delegate = self
		return slider.embedInView(edges: .init(top: 20, left: 10, bottom: 10, right: 10), priority: .init(999))
	}()
	
	private var observer: NSKeyValueObservation?
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.hideNavigationBarLine()
        self.setupStatusBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setupViews()
		selectedTab = tabs.first?.title
		self.observer = tableView.observe(\.contentOffset) { [weak self] scrollView, _ in self?.scrollViewObserver(scrollView) }
    }
    
    func setupViews(){
		view.addSubview(backdropImage)
		view.setWidthForChildWithPadding(backdropImage, paddingFactor: .zero)
		backdropImage.setHeightWithPriority(200)
		
		view.backgroundColor = .surfaceBackground

		view.addSubview(tableView)
		view.setConstraintsToChild(tableView, edgeInsets: .zero)
		tableView.tableHeaderView = profileHeaderView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		backdropImage.removeAllSubViews()
		backdropImage.blurGradientBackDrop(size: backdropImage.compressedFittingSize)
	}
	
//MARK: Protected Methods
		
	private func scrollViewObserver(_ scrollView: UIScrollView) {
		guard scrollView.contentOffset.y > Self.safeAreaInset.top else { return }
		let yOff = scrollView.contentOffset.y
		let height: CGFloat = 200
		backdropImage.transform = .init(translationX: 0, y: -height * (Self.safeAreaInset.top...height).percent(abs(yOff)).clamp(1))
	}
	
	private func buildDataSource() -> TableViewDataSource {
		if selectedTab == NFTArtOfferSection.selectorItem?.title {
			return .init(section: [offers].compactMap { $0 })
		} else if selectedTab == NFTArtSection.selectorItem?.title {
			return .init(section: (items ?? []))
		} else {
			return .init(section: [])
		}
	}
	
	private var segmentedControlSection: TableSection {
		.init(headerView: segmentedControl, rows: [])
	}

	private var offers: TableSection? {
		guard let items = NFTArtOfferSection.items else { return nil }
		let stackedCells: [CellProvider] = items.compactMap(\.nftOffer?.offerCell)
		return .init(headerView: segmentedControl, rows: stackedCells)
	}
	
	private var items: [TableCollectionSection]? {
		guard let items = NFTArtSection.items?.multiDimension(dim: 2) else { return nil }
		let rowViews: [TableCollectionSection] = items.enumerated().compactMap {
			let layout = UICollectionViewFlowLayout.standardFlow
			layout.itemSize.width = (.totalWidth - 20 - layout.minimumLineSpacing).half
			layout.sectionInset = .init(vertical: 0,horizontal: 10)
			let headerView = $0.offset == .zero ? segmentedControl : nil
			let columns = $0.element.compactMap(\.nftArtData?.collectionCell)
			return TableCollectionSection(headerView: headerView, columns: columns, layout: layout, enableScroll: false)
		}
		return rowViews
	}
}

//MARK: - NFTArtDelegate
extension ProfileViewController:NFTArtCellDelegate{
    
    func viewArt(art: NFTModel) {
        self.setupStatusBar()
        self.navigationController?.pushViewController(NFTDetailArtViewController(nftArt: art), animated: true)
    }
    
}

//MARK: - ProfileHeaderDelegate
extension ProfileViewController: ProfileHeaderEventDelegate {
	func clickedOnProfileButton(_ identifier: String) {
		switch identifier {
		case "Wallet":
			onTapWallet()
		case "Favorites":
			onTapFavorites()
		case "Draft":
			onTapDrafts()
		case "Profile":
			onTapProfile()
		default:
			print("(DEBUG) No Action for this button has been assigned!")
		}
	}
}

//MARK: - ButtonHandler
extension ProfileViewController{
    
    func onTapFavorites(){
        self.navigationController?.pushViewController(ProfileAssetCollectionViewController(art: NFTModel.testsArtData ?? [],name: "Favorite"), animated: true)
    }
    
    func onTapDrafts(){
        self.navigationController?.pushViewController(ProfileAssetCollectionViewController(art: NFTModel.testsArtData ?? [], name: "Draft"), animated: true)
    }
    
    func onTapWallet(){
        self.navigationController?.pushViewController(WalletDetailView(), animated: true)
    }
	
	func onTapProfile() {
		self.navigationController?.pushViewController(SettingViewController(), animated: true)
	}
}

//MARK: AccountViewController SliderDelegate

extension ProfileViewController: SlideSelectorDelegate {
	
	func handleSelect(_ id: String) {
		selectedTab = id
	}
}

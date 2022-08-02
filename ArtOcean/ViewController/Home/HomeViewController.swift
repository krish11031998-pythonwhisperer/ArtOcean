//
//  HomeViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit

class HomeViewController: UIViewController {
    

	private var tableView:UITableView?
	private var nfts:[NFTModel]?
	private lazy var datasource:TableViewDataSource = { buildDataSource() }()

	
	func buildDataSource() -> TableViewDataSource{
		.init(section: [liveBidCollection, topCollection, hotItems, popularItems, topSeller].compactMap{ $0 })
	}
	
	private var liveBidCollection:TableCollectionSection? {
		guard let safeNFTs = nfts, !safeNFTs.isEmpty else { return nil }
		let data:[NFTArtCollectionViewCellData] = safeNFTs.map { nft in .init(nft: nft) { [weak self] in self?.viewArt(nft) } }
		let cols = data.map { CollectionColumn<NFTArtCollectionLiveBidViewCell>($0) }
		let size: CGSize = NFTArtCollectionLiveBidViewCell.itemSize
 		return .init(
			title:"Hot Items",
			rightTitle: "View All",
			columns: cols,
			layout: .standardFlowWithSize(size)
		) { [weak self] in self?.pushSeeAllArtVC() }
	}
	
	private var hotItems:TableCollectionSection? {
		guard let safeNFTs = nfts, !safeNFTs.isEmpty else { return nil }
		let data:[NFTArtCollectionViewCellData] = safeNFTs.map { nft in .init(nft: nft) { [weak self] in self?.viewArt(nft) } }
		let cols = data.map { CollectionColumn<NFTArtCollectionViewCell>($0) }
		return .init(
			title:"Hot Items",
			rightTitle: "View All",
			columns: cols,
			layout: .standardFlowWithSize(.init(width: 154, height: 176))
		) { [weak self] in self?.pushSeeAllArtVC() }
	}
	
	private var popularItems:TableCollectionSection? {
		guard let safeNFTs = nfts, !safeNFTs.isEmpty else { return nil }
		let data:[NFTArtCollectionViewCellData] = safeNFTs.map { nft in .init(nft: nft) { [weak self] in self?.viewArt(nft) } }
		let cols = data.map { CollectionColumn<NFTArtCollectionViewCell>($0) }
		return .init(
			title:"Popular Items",
			rightTitle: "View All",
			columns: cols,
			layout: .standardFlowWithSize(.init(width: 154, height: 176))
		) { [weak self] in self?.pushSeeAllArtVC() }
	}

	
	private var topCollection:TableSection{
		let headerView = ContainerHeaderView(title: "Top Collection", rightButtonTitle: "View All") { [weak self] in self?.pushSeeAllArtVC() }
		return .init(headerView: headerView, rows: Array(repeating: TopCollectionData.test, count: 5).compactMap{ TableRow<TopCollectionTableCell>($0) })
	}
	
    private lazy var artTypes:TableSection? = {
		return .init(rows: [TableRow<NFTArtTypeCollectionViewCell>(NFTArtType.allType)])
    }()
	
	private var topSeller:TableCollectionSection?{
		let colsData:[TopSellerCollectionViewData] = Array(repeating: SellerData.test, count: 15).map {seller in .init(seller: seller) { print("(DEBUG) Clicked on ",seller.name) } }
		let cols = colsData.map { CollectionColumn<TopSellerCollectionViewCell>($0) }
		return .init(
			title: "Top Seller",
			rightTitle: "View all",
			columns: cols,
			layout: TopSellerCollectionViewCell.layout,
			height: 96) { [weak self] in self?.pushSeeAllArtVC() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		buildTableView()
		tableView?.reload(with: datasource)
        self.setupStatusBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		loadNFT()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
	
	func buildTableView(){
		tableView = UITableView(frame: .zero, style: .grouped)
		tableView?.backgroundColor = .clear
		tableView?.tableHeaderView = tableHeaderView
		tableView?.separatorStyle = .none
		view.addSubview(tableView!)
		view.setContraintsToChild(tableView!, edgeInsets: .zero)
	}
	
	func loadNFT(){
		guard nfts == nil else {return}
		AlchemyAPI.shared.getNftsFromFile(fileName: "nft") { [weak self] result in
			switch result{
			case .success(let nfts):
				let filterNFTS = nfts.compactMap({$0.metadata?.image?.contains("https") ?? false ? $0 : nil})
				self?.nfts = (filterNFTS.count > 5 ? Array(filterNFTS[0...4]) : filterNFTS)
				print("(DEBUG) Got Data Successffuly !")
				DispatchQueue.main.async {
					guard let safeDatasource = self?.buildDataSource() else { return }
					self?.tableView?.reload(with: safeDatasource)
				}
			case .failure(let err):
				print("(error) err : ",err.localizedDescription)
			}
		}
	}
	
	private func viewArt(_ nft:NFTModel){
		navigationController?.pushViewController(NFTDetailArtViewController(nftArt: nft), animated: true)
	}
	
    
	private var tableHeaderView:UIView {
		
		let view  = UIView(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 206)))
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.spacing = 24
		
		let artTypeCollection = NFTArtTypeCollectionView()
		artTypeCollection.configureCollection(NFTArtType.allType)
		
		stackView.addArrangedSubview(artTypeCollection)
		stackView.addArrangedSubview(bannerImageView)
		
		let imageleading = bannerImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10)
		imageleading.priority = .init(rawValue: 750)
		let imagetrailing = bannerImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10)
		imagetrailing.priority = .init(rawValue: 750)
		
		NSLayoutConstraint.activate([
			imageleading,
			imagetrailing
		])
		
		view.addSubview(stackView)
		view.setContraintsToChild(stackView, edgeInsets: .zero)
		
		return view
	}
	
    func popLivBidVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func pushSeeAllArtVC(){
        let liveBidVC = LiveBidDetailView()
        self.navigationController?.pushViewController(liveBidVC, animated: true)
    }
    
    private lazy var bannerImageView:UIView = {
        let imageView = UIImageView()
        if let safeImg = UIImage(named: "BannerSkeleton"){
            imageView.image = safeImg
		}else{
			imageView.backgroundColor = .black
		}
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        
        
        //LearnMoreImage
        let learnMoreBannerImage = UIImageView()
        learnMoreBannerImage.translatesAutoresizingMaskIntoConstraints = false
        learnMoreBannerImage.contentMode = .scaleAspectFit
        learnMoreBannerImage.image = .init(named: "LearnMoreBannerImage")
        imageView.addSubview(learnMoreBannerImage)
        
        learnMoreBannerImage.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,constant: -20).isActive = true
        learnMoreBannerImage.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 24).isActive = true
        learnMoreBannerImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        learnMoreBannerImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //titlView
        let bannerTitle = self.view.labelBuilder(text: "Collect and Sell extraordinary NFTs", size: 18, weight: .bold, color: .appWhiteBackgroundColor, numOfLines: 2, adjustFontSize: false)
        imageView.addSubview(bannerTitle)
        bannerTitle.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,constant: 24).isActive = true
        bannerTitle.topAnchor.constraint(equalTo: imageView.topAnchor,constant:20).isActive = true
        bannerTitle.bottomAnchor.constraint(equalTo: learnMoreBannerImage.topAnchor, constant: -24).isActive = true
        bannerTitle.widthAnchor.constraint(equalToConstant: 185).isActive = true
        
//		view.heightAnchor.constraint(equalToConstant: 132).isActive = true
		
        return imageView
    }()
    
    private var stackView:UIStackView = {
        let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()

}

//MARK: - NFTLiveBidCollectionDelegate
extension HomeViewController:NFTLiveBidCollectionDelegate{
    func viewAll(allArt: [NFTModel]) {
        let liveBidVC = LiveBidDetailView(nfts: allArt)
        self.navigationController?.pushViewController(liveBidVC, animated: true)
    }
    
    func viewNFT(art: NFTModel) {
        print("(DEBUG) selected An Art : ",art.title ?? "")
        self.navigationController?.pushViewController(NFTDetailArtViewController(nftArt: art), animated: true)
    }
}

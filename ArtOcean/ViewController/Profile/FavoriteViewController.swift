//
//  FavoriteViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 10/06/2022.
//

import Foundation
import UIKit

class ProfileAssetCollectionViewController:UIViewController{
    
    let art:[NFTModel]
    
    private var artCollection:CustomComplexCollectionView!
    
    private var pageName:String = ""
    
	private lazy var searchBar: CustomSearchBar = {
		let searchBar: CustomSearchBar = .init()
		searchBar.delegate = self
		return searchBar
	}()
	
	private lazy var collection: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
		collection.showsHorizontalScrollIndicator = false
		return collection
	}()
	
	private lazy var mainStack: UIStackView = {
		let stack: UIStackView = .VStack(views: [searchBar, collection], spacing: 24)
		collection.setHeightWithPriority(.safeAreaTotalHeight - searchBar.compressedFittingSize.height - 36)
		return stack
	}()
	
	private func buildCollectionDataSource() ->  CollectionDataSource {
		let collectionCells: [CollectionCellProvider] = NFTArtSection.items?.compactMap(\.nftArtData?.collectionCell) ?? []
		return .init(columns: collectionCells, layout: .standardLayout(size:CGSize(width: (.totalWidth - 20).half - 10, height: 225)), height: .infinity)
	}

    
    init(art:[NFTModel],name:String){
        self.art = art
        self.pageName = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
		showNavBar()
        setupNavBar()
		view.addSubview(mainStack)
		view.setSafeAreaConstraintsToChild(mainStack, edgeInsets: .init(top: 12, left: 0, bottom: 0, right: 0))
		collection.reload(with: buildCollectionDataSource())
    }
    
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
    func setupNavBar(){
		let leftBarButton: UIBarButtonItem = .backButton { [weak self] in
			self?.navigationController?.popViewController(animated: true)
		}
		
		let label: UILabel = .init()
		pageName.styled(font: .bold, color: .black, size: 18).renderInto(target: label)
		
        self.navigationItem.leftBarButtonItem = leftBarButton
		self.navigationItem.titleView = label
    }
    
	
    
}

//MARK: - SearchBar Delegate

extension ProfileAssetCollectionViewController: CustomSearchBarDelegate {
	
	func searchWithFilter(_ word: String) { }
}

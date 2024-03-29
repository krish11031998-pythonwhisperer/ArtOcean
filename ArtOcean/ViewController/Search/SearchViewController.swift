//
//  SearchViewController.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 26/06/2022.
//

import Foundation
import UIKit

class SearchViewController:UIViewController{
	
	var searchedNFT:[NFTModel] = []
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavbar()
		setupUI()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		scrollView.frame = view.bounds
	}
	
	//MARK: - Views
	
	private var collectionLayout: UICollectionViewFlowLayout { .standardLayout(size:CGSize(width: (.totalWidth - 20).half - 10, height: 225)) }
	
	private let scrollView:UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		return scrollView
	}()
	
	private lazy var searchBar:CustomSearchBar = {
		let searchBar = CustomSearchBar()
		searchBar.delegate = self
		searchBar.backgroundColor = .surfaceBackground
		return searchBar
	}()
	
	private let collectionView:UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
		collection.showsVerticalScrollIndicator = false
		collection.showsHorizontalScrollIndicator = false
		collection.backgroundColor = .surfaceBackground
		return collection
	}()
	
	func setupCollectionView(){
		view.addSubview(collectionView)
		view.setSafeAreaConstraintsToChild(collectionView, edgeInsets: .init(top: searchBar.compressedFittingSize.height + 50, left: 0, bottom: 0, right: 0))
	}
	
	//MARK: - Setting Up View
	
	func setupNavbar(){
		let label = UILabel()
		"Search".heading3().renderInto(target: label)
		let leftBarItem = UIBarButtonItem(customView: label)
		setupStatusBar()
		navigationItem.leftBarButtonItem = leftBarItem
	}
	
	func setupUI(){
		let stackView: UIStackView = .VStack(views: [.spacer(height: 12),searchBar,NFTArtTypeCollectionView()], spacing: 20, aligmment: .center)
		searchBar.setHeightWithPriority(55,priority: .required)
		view.addSubview(scrollView)
		scrollView.addSubview(stackView)
		scrollView.setConstraintsToChild(stackView, edgeInsets: .zero)
		view.setSafeAreaConstraintsToChild(scrollView, edgeInsets: .zero)
		view.backgroundColor = .surfaceBackground
	}
	
}

//MARK: - CustomSearchBarDelegate
extension SearchViewController:CustomSearchBarDelegate{
	
	func searchWithFilter(_ word: String) {
		if word.isEmpty{
			searchedNFT.removeAll()
			collectionView.removeFromSuperview()
			return
		}
		
		guard let safeTestData = NFTModel.testsArtData else {return}
		let searchFilterData = safeTestData.filter({$0.Title.contains(word)})
		print("(DEBUG) searchedText : \(word) and results : \(searchFilterData.compactMap({$0.Title}))")
		collectionView.reload(with: .init(columns: searchFilterData.map(\.collectionCell), layout: collectionLayout, height: .infinity))
		setupCollectionView()
	}
	
}

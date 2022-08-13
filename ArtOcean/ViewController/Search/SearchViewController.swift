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
	
	private let scrollView:UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		return scrollView
	}()
	
	private lazy var searchBar:CustomSearchBar = {
		let searchBar = CustomSearchBar()
		searchBar.delegate = self
		return searchBar
	}()
	
	private let collectionView:UICollectionView = {
		let layout:UICollectionViewFlowLayout = .standardLayout(size:CGSize(width: UIScreen.main.bounds.width - 20, height: 306))
		let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collection.showsVerticalScrollIndicator = false
		collection.showsHorizontalScrollIndicator = false
		collection.register(NFTArtCollectionLiveBidViewCell.self, forCellWithReuseIdentifier: NFTArtCollectionLiveBidViewCell.identifier)
		collection.backgroundColor = .white
		return collection
	}()
	
	func setupCollectionView(){
		view.addSubview(collectionView)
		collectionView.dataSource = self
		view.setSafeAreaConstraintsToChild(collectionView, edgeInsets: .zero)
	}
	
	//MARK: - Setting Up View
	
	func setupNavbar(){
		let label = CustomLabel(text: "Search", size: 22, weight: .bold, color: .black, numOfLines: 1)
		let leftBarItem = UIBarButtonItem(customView: label)
		
		navigationItem.leftBarButtonItem = leftBarItem
	}
	
	
	func setupUI(){
		let stackView: UIStackView = .VStack(views: [.spacer(height: 25),searchBar,NFTArtTypeCollectionView()], spacing: 20, aligmment: .center)
		searchBar.setHeightWithPriority(55,priority: .init(rawValue: 999))
		view.addSubview(scrollView)
		scrollView.addSubview(stackView)
		scrollView.setContraintsToChild(stackView, edgeInsets: .zero)
		view.setSafeAreaConstraintsToChild(scrollView, edgeInsets: .zero)
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
		searchedNFT = searchFilterData
		collectionView.reloadData()
		setupCollectionView()
	}
	
}

//MARK: - UICollectionViewDelegate
extension SearchViewController:UICollectionViewDataSource{
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTArtCollectionLiveBidViewCell.identifier, for: indexPath) as? NFTArtCollectionLiveBidViewCell else {return UICollectionViewCell()}
		let data = searchedNFT[indexPath.row]
		cell.updateUIWithNFT(data)
		return cell
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return searchedNFT.count
	}
	
}

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
    
    private lazy var searchView:UIView = {
        let view = UIStackView()
        view.spacing = 18.5
        
        var textField = UITextField()
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(string: "Search For Items", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appGrayColor,NSAttributedString.Key.font : UIFont(name: "Satoshi-Medium", size: 14)!])
        textField.font = UIFont(name: "Satoshi-Medium", size: 14)!
        textField.textColor = .black
        textField.setContentHuggingPriority(.init(249), for: .horizontal)
        textField.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        textField.layer.cornerRadius = 12
        
        let imageView = UIImageView()
        imageView.image = .init(named: "search")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        view.addArrangedSubview(imageView)
        view.addArrangedSubview(textField)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.appGrayColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(top: 10, left: 25, bottom: 10, right: 25)
        
        return view
    }()
    
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
        if let safeNavbar = self.navigationController?.navigationBar, safeNavbar.isHidden{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        artCollection = CustomComplexCollectionView(sections: [.init(type: "ART", items: art.compactMap({.artData($0)}))], layoutForSections: ["ART":.standardVerticalTwoByTwoGrid], singleSection: true)
        artCollection.configurationDelegate = self
        self.view.addSubview(searchView)
        self.view.addSubview(artCollection)
        self.setupNavBar()
        self.setupLayout()
    }
    
    func setupNavBar(){
        let leftBarItem:UIBarButtonItem = .init(customView: CustomButton(frame: .init(origin: .zero, size: .init(width: 30, height: 30)), cornerRadius: 15, systemName: "chevron.left", handler: {
            self.navigationController?.popViewController(animated: true)
        }, autolayout: false))
        let titleView:UIView = CustomLabel(text: pageName, size: 18, weight: .bold, color: .black, numOfLines: 1, adjustFontSize: true, autoLayout: false)
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationItem.titleView  = titleView
    }
    
    func setupLayout(){
        self.searchView.topAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.topAnchor, multiplier: 3).isActive = true
        self.searchView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 3).isActive = true
        self.view.trailingAnchor.constraint(equalToSystemSpacingAfter: self.searchView.trailingAnchor, multiplier: 3).isActive = true
        self.searchView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        
        self.artCollection.topAnchor.constraint(equalToSystemSpacingBelow: self.searchView.bottomAnchor, multiplier: 3).isActive = true
        self.artCollection.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor).isActive = true
        self.artCollection.trailingAnchor.constraint(equalTo:self.searchView.trailingAnchor).isActive = true
        self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: self.artCollection.bottomAnchor, multiplier: 0).isActive = true
    }
    
}

//MARK: - CustomComplexCollectionViewDelegate
extension ProfileAssetCollectionViewController:CustomComplexCollectionViewDelegate{
    func registerCellToCollection(_ collection: UICollectionView) {
        collection.register(NFTArtCollectionViewCell.self, forCellWithReuseIdentifier: NFTArtCollectionViewCell.identifier)
    }
    
    func cellForCollection(_ collection: UICollectionView, _ section: SectionType, _ indexPath: IndexPath, _ item: Item) -> ConfirgurableCell? {
        switch section{
        case "ART":
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: NFTArtCollectionViewCell.identifier, for: indexPath) as? NFTArtCollectionViewCell else { return nil}
            
            cell.configure(item)
            cell.delegate = self
            return cell
        default:
            return nil
        }
    }
}

//MARK: - CustomComplexCollection CustomButton
extension ProfileAssetCollectionViewController:NFTArtCellDelegate{
    
    func viewArt(art: NFTModel) {
        self.navigationController?.pushViewController(NFTDetailArtViewController(nftArt: art), animated: true)
    }
}

//
//  CustomComplexCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 05/06/2022.
//

import Foundation
import UIKit


protocol CustomComplexCollectionViewDelegate{
    func registerCellToCollection(_ collection:UICollectionView)
    func cellForCollection(_ collection:UICollectionView,_ section:SectionType,_ indexPath:IndexPath,_ item:Item) -> ConfirgurableCell?
}

class CustomComplexCollectionView:UICollectionView{
    
    private var sections:[Section]
    private var layoutForSections:[SectionType:NSCollectionLayoutSection]
    public var configurationDelegate:CustomComplexCollectionViewDelegate? = nil{
        didSet{
            self.setupCollection()
        }
    }
    private var selectedSection:SectionType?
    private var collectionDataSource:UICollectionViewDiffableDataSource<Section,Item>? = nil
    private var singleSection:Bool
    
    init(sections:[Section],layoutForSections:[SectionType:NSCollectionLayoutSection],singleSection:Bool = false){
        self.sections = sections
        self.layoutForSections = layoutForSections
        self.singleSection = singleSection
        if singleSection{
            self.selectedSection = sections.first?.type
        }else{
            self.selectedSection = nil
        }
        super.init(frame: .zero, collectionViewLayout: .init())
        self.collectionViewLayout = self.configureLayout()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showsVerticalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .clear
        
    }
    

    private func registerCell(){
        self.configurationDelegate?.registerCellToCollection(self)
    }
    
    func configureLayout() -> UICollectionViewCompositionalLayout{
        let complexLayout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            if let safeSelectedSection = self.selectedSection{
                if let layout = self.layoutForSections[safeSelectedSection]{
                    return layout
                }else{
                    return .basicLayout
                }
            }else if let type = self.sections[sectionIndex].type{
                if let layout = self.layoutForSections[type]{
                    return layout
                }else{
                    let itemLayout:NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                    
                    let groupLayout:NSCollectionLayoutGroup = .vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),subitems: [itemLayout])

                    
                    let layout:NSCollectionLayoutSection = .init(group: groupLayout)
                    
                    return layout
                }
            }else{
                return .basicLayout
            }
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        complexLayout.configuration = config
        
        return complexLayout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCollectionCell<T:ConfirgurableCell>(_ cellType:T.Type,index:IndexPath,item:Item) -> T?{
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: index) as? T else{
            fatalError("(DEBUG) Have not registered/provided a cell for id : \(T.identifier)")
        }
        
        cell.configure(item)
        
        return cell
    }
    
    
    private func configureDataSource(){
        self.collectionDataSource = UICollectionViewDiffableDataSource(collectionView: self, cellProvider: { collectionView, indexPath, item in
            
            if let safeSelectedSection = self.selectedSection{
                guard let cell = self.configurationDelegate?.cellForCollection(collectionView,safeSelectedSection, indexPath, item) else {
                    return UICollectionViewCell()
                }
                return cell
            }else{
                guard let sectionType = self.sections[indexPath.section].type else {
                    return nil
                }
                guard let cell = self.configurationDelegate?.cellForCollection(collectionView,sectionType, indexPath, item) else {
                    return nil
                }
                return cell
            }
        })
    }

    
    public func setupCollection(){
        self.registerCell()
        self.configureDataSource()
        self.reloadCollectionView(singleSection ? sections.first?.type : nil)
    }
    
    
    public func reloadCollectionView(_ sectionType:String? = nil){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        if let selectedSection = sectionType{
            self.selectedSection = sectionType
            if let section = self.sections.first(where: {$0.type == selectedSection}),let items = section.items{
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }
        }else{
            snapshot.appendSections(self.sections)
            
            for section in sections {
                if let items = section.items{
                    snapshot.appendItems(items, toSection: section)
                }
            }
        }
        self.collectionDataSource?.apply(snapshot)
    }
    
}

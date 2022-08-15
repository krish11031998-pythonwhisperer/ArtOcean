//
//  CustomSelectorCollectionView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 05/06/2022.
//

import Foundation
import UIKit

protocol CustomSelectorCollectionViewDelegate{
    func registerCells<T:ConfirgurableCell>(_ cells:[T])
}

class CustomSelectorCollectionView:UIView{
    
    private let sections:[Section]
    private let layoutForSection:[SectionType:NSCollectionLayoutSection]
//    private let cellForSections:[Section:T.Type] = [:]
    public var collectionDelegate:CustomComplexCollectionViewDelegate? = nil{
        didSet{
            self.customCollectionView.configurationDelegate = self.collectionDelegate
        }
    }
    
    init(sections:[Section],layoutForSections:[SectionType:NSCollectionLayoutSection]){
        self.sections = sections
        self.layoutForSection = layoutForSections
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupViews()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var customCollectionView:CustomComplexCollectionView = {
        let collectionView = CustomComplexCollectionView(sections: self.sections, layoutForSections: self.layoutForSection, singleSection: true)
        return collectionView
    }()
    
    public lazy var selector:SliderSelector = {
        let selector = SliderSelector(tabs: self.sections.compactMap({$0.type}))
        selector.delegate = self
        return selector
    }()
    
    
    func setupViews(){
        self.addSubview(self.selector)
        self.addSubview(self.customCollectionView)
    }
    
    func setupLayout(){
        self.selector.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.selector.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.selector.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.selector.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        self.customCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: self.selector.bottomAnchor, multiplier: 3).isActive = true
        self.customCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.customCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.customCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}


//MARK: - CustomSelectorCollectionView SlideSelectorDelegate
extension CustomSelectorCollectionView:SlideSelectorDelegate{
    
    func handleSelect(_ id: String) {
        self.customCollectionView.reloadCollectionView(id)
    }
}

//MARK: - Defination

protocol CustomSelectorDynamicCollectionDelegate {
	
	func collectionSection(_ section: Section) -> CollectionSection?
}

//MARK: - Type

class CustomSelectorDynamicCollectionView: UIView {
	
//MARK: - Properties
	
	private let sections: [Section]
	
	public var delegate: CustomSelectorDynamicCollectionDelegate? {
		didSet {
			reloadCollection()
		}
	}
	
	private var selectedSection: Section? {
		didSet {
			reloadCollection()
		}
	}
	
	private lazy var collectionView: UICollectionView = {
		return .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.standardFlow)
	}()
	
	private lazy var selector:SliderSelector = {
		let selector = SliderSelector(tabs: self.sections.compactMap({$0.type}))
		selector.delegate = self
		return selector
	}()
	
	
	
	//MARK: - Constructors
	
	init(sections:[ Section]){
		self.sections = sections
		super.init(frame: .zero)
		selectedSection = sections.first
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Protected Methods

	private func setupUI() {
		collectionView.backgroundColor = .clear
		let stack = UIStackView(arrangedSubviews: [selector,collectionView])
		stack.axis = .vertical
		stack.spacing = 20
		selector.setHeightWithPriority(50,priority: .defaultHigh)
		addSubview(stack)
		setConstraintsToChild(stack, edgeInsets: .zero)
	}
	
	private func reloadCollection() {
		guard
			let validSelectedSection = selectedSection,
			let validCollectionSection = delegate?.collectionSection(validSelectedSection)
		else { return }
		collectionView.reload(with: .init(sections: [validCollectionSection], layout: validSelectedSection.layout,height: .infinity))
	}
}

//MARK: - CustomSelectorDynamicCollectionView SlideSelectorDelegate
extension CustomSelectorDynamicCollectionView:SlideSelectorDelegate{
	
	func handleSelect(_ id: String) {
        if let section = self.sections.first(where: {$0.type == id}){
			selectedSection = section
        }
	}
	
}

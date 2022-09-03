//
//  SliderSelectorView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 01/06/2022.
//

import Foundation
import UIKit

protocol SlideSelectorDelegate{
    func handleSelect(_ id:String)
}

struct SlideSelectorItem {
	var title: String
	var image: UIImage?
}

extension SlideSelectorItem: Hashable {
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(title)
	}
}
class SliderSelector:UIView{
    
    public var delegate:SlideSelectorDelegate? = nil
    private var hoverViewCenterX:NSLayoutConstraint? = nil
    private var tabs:[SlideSelectorItem]
    
    init(tabs:[SlideSelectorItem]){
        self.tabs = tabs
		super.init(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width - 20, height: 50)))
		setupUI()
    }
    
    required init?(coder: NSCoder) {
		self.tabs = []
		super.init(coder: coder)
    }
    
	private func setupUI() {
		cornerRadius = 20
		backgroundColor = interface == .dark ? .appIndigo : .surfaceBackgroundInverse.withAlphaComponent(0.5)
		tabStackBuilder()
	}
	
    private lazy var tabsIndicators:[UIButton] = {
        let views:[UIButton] = self.tabs.compactMap { tab in
			let button = CustomLabelButton()
			button.title = tab.title.heading5(color: .textColor)
			button.image = tab.image?.resized(.squared(15)).withTintColor(.surfaceBackgroundInverse)
			button.accessibilityIdentifier = tab.title
			button.handler = { [weak self] in self?.tapHandler(tab.title) }
            return button
        }
		
		if let first = views.first(where: tabs.first?.title) as? CustomLabelButton {
			first.isSelected = true
		}
        return views
    }()
    
	func tapHandler(_ tab: String) {
		UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
			guard let selectedView = self.tabsIndicators.first(where: tab) as? CustomLabelButton else { return }
			selectedView.isSelected = true
			self.tabsIndicators.filterViews(exclude: tab)?.forEach { $0.isSelected = false }
		}.startAnimation()
		self.delegate?.handleSelect(tab)
	}

    
    func tabStackBuilder(){
        let stackView = UIView.StackBuilder(views: tabsIndicators, ratios: [0.5,0.5], spacing: 10, axis: .horizontal)
        addSubview(stackView)
		setConstraintsToChild(stackView, edgeInsets: .init(vertical: 5, horizontal: 5))
    }
    
    
    override var intrinsicContentSize: CGSize{
        return .init(width: UIScreen.main.bounds.width - 20, height: 50)
    }
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		removeAllSubViews()
		setupUI()
	}
    
}

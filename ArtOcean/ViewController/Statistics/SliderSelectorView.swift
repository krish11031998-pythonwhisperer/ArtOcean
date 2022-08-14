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

class SliderSelector:UIView{
    
    public var delegate:SlideSelectorDelegate? = nil
    private var hoverViewCenterX:NSLayoutConstraint? = nil
    private var tabs:[String]
    
    init(tabs:[String]){
        self.tabs = tabs
        super.init(frame: .zero)
        cornerRadius = 20
        backgroundColor = UIColor(red: 0.953, green: 0.969, blue: 0.976, alpha: 1)
        tabStackBuilder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tabsIndicators:[UIView] = {
        let views:[UIView] = self.tabs.compactMap { tab in
			let button = CustomLabelButton(title: tab.capitalized,
										   image: .init(named:tab.lowercased()),
										   font: CustomFonts.medium,
										   size: 15,
										   color: .appBlackColor,
										   backgroundColor: .clear)
			button.accessibilityIdentifier = tab
			button.handler = { [weak self] in
				self?.tapHandler(tab)
			}
            return button
        }
		if let first = views.first(where: tabs.first) {
			first.backgroundColor = .white
			first.cornerRadius = 15
		}
        return views
    }()
    
	func tapHandler(_ tab: String) {
		UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
			guard let selectedView = self.tabsIndicators.first(where: tab) else { return }
			selectedView.backgroundColor = .white
			selectedView.cornerRadius = 15
			self.tabsIndicators.filterViews(exclude: tab)?.forEach { $0.backgroundColor = .clear }
		}.startAnimation()
		self.delegate?.handleSelect(tab)
	}

    
    func tabStackBuilder(){
        let ratios = Array(repeating: CGFloat(1)/CGFloat(tabsIndicators.count), count: tabsIndicators.count)
        print("(DEBUG) ratios : ",ratios)
        let stackView = UIView.StackBuilder(views: tabsIndicators, ratios: [0.5,0.5], spacing: 10, axis: .horizontal)
        addSubview(stackView)
		setContraintsToChild(stackView, edgeInsets: .init(vertical: 5, horizontal: 5))
    }
    
    
    override var intrinsicContentSize: CGSize{
        return .init(width: UIScreen.main.bounds.width - 20, height: 50)
    }
    
}

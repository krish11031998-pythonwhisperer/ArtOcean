//
//  AcoordianStackView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 20/08/2022.
//

import Foundation
import UIKit

extension UIView {
	
	func hideView() {
		isHidden = true
	}
	
	func showView() {
		isHidden = false
	}
}

extension UIStackView {
	
	var fittingAccordianSize: CGSize {
		stackFittingSize()
	}
	
}

class AccordianStackView: UIStackView {

//MARK: Properties
	
	private var showAll: Bool = false
	private var limit: Int = 0
	
//MARK: Constructors
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupStack()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)
		setupStack()
	}
	
//MARK: Protected Methods
	
	private func setupStack() {
		axis = .vertical
		distribution = .fill
		spacing = 12
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
	}
	
	@objc
	private func handleTap() {
		showAll.toggle()
		let isHidden = !showAll
		let opacity: CGFloat = showAll ? 1 : 0
		
		let opacityDuration: TimeInterval = 0.4
		
		let animatableViews = self.arrangedSubviews.lastNViews(self.limit)
		
		UIView.viewAnimation {
			
			if self.showAll {
				animatableViews.forEach { $0.showView() }
			} else {
				animatableViews.forEach { $0.alpha = opacity }
			}
		}
		
		UIView.viewAnimation(duration: opacityDuration, delay: .defaultAnimationDuration * 0.25) {
			if self.showAll {
				animatableViews.forEach { $0.alpha = opacity }
			} else {
				animatableViews.forEach { $0.hideView() }
			}
		}
	}
	
//MARK: Exposed Methods
	
	public func configureAccordian(_ views: [UIView], innerSize: CGSize, with: CGFloat, limit: Int = 2) {
		buildFlexibleGrid(views, innerSize: innerSize, with: with)
	}
	
	public func hideElement(_ limit: Int) {
		self.limit = limit
		hideStackElements(limit: limit)
	}
}

//
//  StickyFooterView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 02/09/2022.
//

import Foundation
import UIKit

extension UIView {
	
	var safeAreaInset: UIEdgeInsets { UIWindow.safeAreaInset }
}

class StickyFooterView: UIView {
	
//MARK: - Properties
	private var innerView: UIView
	
	private var wrappedView: UIView {
		let resultingView = innerView.embedInView(edges: .init(top: 12, left: 24, bottom: safeAreaInset.bottom, right: 24))
		resultingView.backgroundColor = .surfaceBackground
		return resultingView
	}
	
//MARK: - Constructors
	init(innerView: UIView) {
		self.innerView = innerView
		super.init(frame: .zero)
		buildView()
	}
	
	required init?(coder: NSCoder) {
		self.innerView = .clearView()
		super.init(coder: coder)
		buildView()
	}

//MARK: - Overriden Methods

//MARK: - Exposed Methods
	
//MARK: - Protected Methods

	private func buildView() {
		let resultingView = innerView.embedInView(edges: .init(top: 12, left: 24, bottom: safeAreaInset.bottom, right: 24))
		resultingView.backgroundColor = .surfaceBackground
		addSubview(resultingView)
		setConstraintsToChild(resultingView, edgeInsets: .zero)
	}
	
	public func showFooter() {
		guard let window = UIWindow.key else { return }
		
		window.addSubview(self)
		window.setWidthForChildWithPadding(self, paddingFactor: 0)
		window.setFrameLayout(childView: self, alignment: .bottom)
		
		transform = .init(translationX: 0, y: compressedFittingSize.height)
		
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
			self.transform = .init(translationX: 0, y: 0)
		} completion: { isFinished in
			if isFinished { NotificationCenter.default.post(name: .stickyFooterShown, object: nil) }
		}
	}
	
	public func hideFooter() {
		
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
			self.transform = .init(translationX: 0, y: self.compressedFittingSize.height)
		} completion: { isFinished in
			if isFinished {
				self.removeFromSuperview()
				NotificationCenter.default.post(name: .stickyFooterHidden, object: nil)
			}
		}
	}
}

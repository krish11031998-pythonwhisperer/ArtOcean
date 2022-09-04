//
//  StretchyHeaderView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 05/06/2022.
//

import Foundation
import UIKit

extension Array where Element == UIColor {
	
	static var gradientColors: [UIColor] =  [.clear, .surfaceBackground.withAlphaComponent(0.5), .surfaceBackground]
	
}

class StreachyHeaderView:UIView{
    
    private var viewHeightConstraint:NSLayoutConstraint? = nil
    private var viewTopConstraint:NSLayoutConstraint? = nil
	private var height:CGFloat = .zero
    private let innerView:UIView
	private let gradientColors: [UIColor]
	private var gradientView: UIView = { .init() }()
	
	private var viewSize: CGSize { .init(width: .totalWidth, height: height) }
	
	init(height:CGFloat, innerView:UIView, gradientColors: [UIColor] = .gradientColors){
		self.gradientColors = gradientColors
		self.height = height
		self.innerView = innerView
		super.init(frame: .zero)
		setupView()
		setupLayout()
    }
    
    required init?(coder: NSCoder) {
		innerView = .init()
		gradientColors = .gradientColors
		super.init(coder: coder)
    }
    
	private func setupView() {
		addSubview(innerView)
		addSubview(gradientView)
	}
	
    func setupLayout(){
		innerView.removeAllConstraints()
		setWidthForChildWithPadding(innerView, paddingFactor: 0)
        viewTopConstraint = innerView.topAnchor.constraint(equalTo: topAnchor)
        viewTopConstraint?.isActive = true
        viewHeightConstraint =  innerView.heightAnchor.constraint(equalToConstant: height)
        viewHeightConstraint?.isActive = true
		
		gradientView.setConstraintsWithParent(edgeInsets: .zero)
		gradientView.addGradientLayer(colors: gradientColors, size: viewSize)
		
		setFrameConstraints(size: viewSize)
    }
    
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		removeAllSubViews()
		setupView()
		setupLayout()
	}
    
    //MARK: - StretchOnScroll
    
	public func stretchOnScroll(_ scrollView:UIScrollView) {
		guard scrollView.contentOffset.y < 0 else { return }
		let y_offset = scrollView.contentOffset.y
		innerView.clipsToBounds = true
		let computedHeight = max(height - y_offset,height)
		viewHeightConstraint?.constant = computedHeight
		viewTopConstraint?.constant =  y_offset
		let alpha: CGFloat = 1 - (0...20).precent(abs(scrollView.contentOffset.y))
		gradientView.alpha = alpha
	}
}

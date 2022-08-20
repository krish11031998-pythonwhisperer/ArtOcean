//
//  ScrollableStackView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 20/08/2022.
//

import Foundation
import UIKit

class ScrollableStackView: UIView {
	
//MARK: - Properties
	private var didUpdateConstraints: Bool = false
	private var stackView: UIStackView = { .VStack() }()
	private var scrollView: UIScrollView = {
		let scroll = UIScrollView()
		scroll.backgroundColor = .clear
		return scroll
	}()
	
	
//MARK: - Protected Methods
	
	private func setDimensionConstraints() {
		if stackView.axis == .vertical {
			scrollView.setEqualWidth(stackView)
		} else {
			scrollView.setEqualHeight(stackView)
		}
	}
	
	private func setupUI() {
		clipsToBounds = true
		addSubview(scrollView)
		scrollView.addSubview(stackView)
		setSafeAreaConstraintsToChild(scrollView, edgeInsets: .zero)
		scrollView.setConstraintsToChild(stackView, edgeInsets: .init(top: 20, left: 0, bottom: 0, right: 0))
		setDimensionConstraints()
	}
	
//MARK: - Overriden Methods
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
}

//MARK: - Exposed Properties Extension

extension ScrollableStackView {
	
	public var spacing: CGFloat {
		get { stackView.spacing }
		set { stackView.spacing = newValue }
	}
	
	public var distribution: UIStackView.Distribution {
		get { stackView.distribution }
		set { stackView.distribution = newValue }
	}
	
	public var aligment: UIStackView.Alignment {
		get { stackView.alignment }
		set { stackView.alignment = newValue }
	}
	
	public var scrollBarInset: UIEdgeInsets {
		get { stackView.axis == .horizontal ? scrollView.horizontalScrollIndicatorInsets : scrollView.verticalScrollIndicatorInsets }
		set {
			if stackView.axis == .horizontal {
				scrollView.horizontalScrollIndicatorInsets = newValue
			} else {
				scrollView.verticalScrollIndicatorInsets = newValue
			}
		}
	}
	
	public var stackAxis: NSLayoutConstraint.Axis {
		get { stackView.axis }
		set {
			
			guard stackView.axis != newValue else { return }
			stackView.axis = newValue
			setDimensionConstraints()
		}
	}
	
	public var scrollViewInset: UIEdgeInsets {
		scrollView.adjustedContentInset
	}
	
	public func addArrangedSubview(_ view: UIView) {
		let compactSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		if stackView.axis == .vertical {
			view.setHeightWithPriority(compactSize.height, priority: .defaultHigh)
		} else {
			view.setWidthWithPriority(compactSize.width, priority: .defaultHigh)
		}
		stackView.addArrangedSubview(view)
	}
	
	public func addArrangedSubview(_ view: UIView, withWidthFactor: CGFloat) {
		addArrangedSubview(view)
		stackView.setWidthForChildWithPadding(view, paddingFactor: withWidthFactor)
	}
	
	public func addArrangedSubview(_ view: UIView, withHeightFactor: CGFloat) {
		addArrangedSubview(view)
		stackView.setHeightForChildWithPadding(view, paddingFactor: withHeightFactor)
	}
	
	public func insertArrangedSubview(_ view: UIView, at: Int) {
		stackView.insertArrangedSubview(view, at: at)
	}
	
	public func removeArrangedView(_ view: UIView) {
		stackView.removeArrangedSubview(view)
	}
	
	public func setCustomSpacing(_ spacing: CGFloat?, after view: UIView) {
		guard let validSpacing = spacing else { return }
		stackView.setCustomSpacing(validSpacing, after: view)
	}
}

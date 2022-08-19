//
//  UIStackView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 09/08/2022.
//

import Foundation
import UIKit

extension UIStackView {
	
	static func VStack(views:[UIView] = [],spacing: CGFloat = .zero, aligmment: Alignment = .fill) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: views)
		stack.axis = .vertical
		stack.spacing = spacing
		stack.alignment = aligmment
		return stack
	}
	
	static func HStack(views:[UIView] = [],spacing: CGFloat = .zero, aligmment: Alignment) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: views)
		stack.axis = .horizontal
		stack.spacing = spacing
		stack.alignment = aligmment
		return stack
	}
	
	func addArrangedSubViewsWithSpacing(view: UIView, spacing: CGFloat = 8) {
		addArrangedSubview(view)
		setCustomSpacing(spacing, after: view)
	}
}

//MARK: CustomStackBuilder

extension UIStackView {
	
	func buildFlexibleGrid(_ views: [UIView], innerSize: CGSize, with spacing: CGFloat) {
		views.sizeFittingStack(for: innerSize.width, with: spacing).forEach { rowViews in
			let stack: UIStackView = .HStack(spacing: 5, aligmment: .fill)
			
			rowViews.forEach(stack.addArrangedSubview(_:))
			stack.addArrangedSubview(.spacer())
			
			addArrangedSubview(stack)
			setWidthForChildWithPadding(stack, paddingFactor: .zero)
		}
	}
	
}

extension Array where Element : UIView {
	
	func sizeFittingStack(for width: CGFloat, with spacing: CGFloat = .zero) -> [[UIView]] {
		var result: [[UIView]] = []
		
		var rowStack: [UIView] = []
		var remainingSpace = width
		
		forEach {

			let size = $0.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
			let itemSize = remainingSpace
			
			if size.width == width {
				result.append([$0])
			} else if size.width >= remainingSpace {
				if !rowStack.isEmpty { result.append(rowStack) }
				rowStack.removeAll()
				remainingSpace = width
			}
			
			rowStack.append($0)
			remainingSpace -= size.width + spacing
		}
		
		if !rowStack.isEmpty { result.append(rowStack) }
		
		return result
	}
	
}

//
//  UIStackView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 09/08/2022.
//

import Foundation
import UIKit

extension UIStackView {
	
	static func VStack(spacing: CGFloat = .zero, aligmment: Alignment = .fill) -> UIStackView {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = spacing
		stack.alignment = aligmment
		return stack
	}
	
	static func HStack(spacing: CGFloat = .zero, aligmment: Alignment) -> UIStackView {
		let stack = UIStackView()
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

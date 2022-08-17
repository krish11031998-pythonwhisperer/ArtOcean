//
//  String.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 08/08/2022.
//

import Foundation
import UIKit

protocol RenderableText {
	func styled(font: CustomFonts, color: UIColor, size: CGFloat) -> NSAttributedString
	func renderInto(target: Any?)
}

extension String {
	
	func replace(withDefault: String = "XXXXX") -> String { !self.isEmpty ? self : withDefault }
	
	func initials() -> String { split(separator: " ").compactMap { $0.first }.reduceToString() }
	
	func heading1() -> RenderableText { styled(font: .black, color: .black, size: 32) }
	func heading2() -> RenderableText { styled(font: .black, color: .black, size: 24) }
	func heading3() -> RenderableText { styled(font: .bold, color: .black, size: 22) }
	func heading4() -> RenderableText { styled(font: .bold, color: .black, size: 18) }
	func heading5() -> RenderableText { styled(font: .bold, color: .black, size: 14) }
	func heading6() -> RenderableText { styled(font: .bold, color: .black, size: 12) }
	func body1Bold() -> RenderableText { styled(font: .bold, color: .black, size: 16) }
	func body1Medium() -> RenderableText { styled(font: .medium, color: .black, size: 16) }
	func body1Regular() -> RenderableText { styled(font: .regular, color: .black, size: 16) }
	func body2Medium() -> RenderableText { styled(font: .medium, color: .black, size: 14) }
	func body2Regular() -> RenderableText { styled(font: .regular, color: .black, size: 14) }
	func body3Medium() -> RenderableText { styled(font: .medium, color: .black, size: 12) }
	func body3Regular() -> RenderableText { styled(font: .regular, color: .black, size: 12) }
	func bodySmallRegular() -> RenderableText { styled(font: .regular, color: .black, size: 11) }
	func largeBodyRegular() -> RenderableText { styled(font: .regular, color: .black, size: 16) }
	
	
}

extension Array where Element == Character {
	
	func reduceToString() ->  String { reduce("", { $0.isEmpty ? String($1) : $0 + String($1) } ) }
	
}

extension String: RenderableText {
	
	func styled(font: CustomFonts, color: UIColor, size: CGFloat) -> NSAttributedString {
		let attributes: [NSAttributedString.Key:Any] = [
			.font: font.fontBuilder(size: size) ?? .systemFont(ofSize: size),
			.foregroundColor: color,
		]
		
		return .init(string: self, attributes: attributes)
	}
	
	func renderInto(target: Any?) {
		switch target {
		case let label as UILabel:
			label.text = self
		default:
			break
		}
	}
	
	func label() -> UILabel {
		let label = UILabel()
		renderInto(target: label)
		return label
	}
	
	func replace(val: String) -> String {
		return replacingOccurrences(of: "{}", with: val)
	}
}



extension NSAttributedString: RenderableText {
	
	func styled(font: CustomFonts, color: UIColor, size: CGFloat) -> NSAttributedString {
		let attributes: [NSAttributedString.Key:Any] = [
			.font: font.fontBuilder(size: size) ?? .systemFont(ofSize: size),
			.foregroundColor: color,
		]
	
		let attributedString = NSMutableAttributedString(attributedString: self)
		attributedString.addAttributes(attributes, range: .init(location: 0, length: attributedString.length))
		return .init(attributedString: attributedString)
	}
	
	func renderInto(target: Any?) {
		switch target {
		case let label as UILabel:
			label.attributedText = self
		case let button as UIButton:
			button.configuration?.attributedTitle = .init(self)
		default:
			break
		}
	}
	
	func label() -> UILabel {
		let label = UILabel()
		renderInto(target: label)
		return label
	}
}

extension Array where Element == UILabel {
	
	func sizeFittingStack(for width: CGFloat, with spacing: CGFloat, padding: CGFloat) -> [[UIView]] {
		var result: [[UIView]] = []
		
		var rowStack: [UIView] = []
		var remainingSpace = width
		
		forEach {

			let size = $0.sizeThatFits(.init(width: width, height: .totalHeight))
			let itemSize = remainingSpace - spacing - padding
			
			if size.width == width {
				result.append([$0])
			} else if size.width >= itemSize {
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

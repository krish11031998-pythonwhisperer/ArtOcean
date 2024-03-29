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
	var attributedString: NSAttributedString { get }
}

extension RenderableText {
	
	static func + (lhs: RenderableText, rhs: RenderableText) -> Self { lhs + rhs }
	
}

extension String {
	
	func replace(withDefault: String = "XXXXX") -> String { !self.isEmpty ? self : withDefault }
	
	func initials() -> String { split(separator: " ").compactMap { $0.first }.limit(to: 2).reduceToString() }
	
	func heading1(color: UIColor = .textColor) -> RenderableText { styled(font: .black, color: color, size: 32) }
	func heading2(color: UIColor = .textColor) -> RenderableText { styled(font: .black, color: color, size: 24) }
	func heading3(color: UIColor = .textColor) -> RenderableText { styled(font: .bold, color: color, size: 22) }
	func heading4(color: UIColor = .textColor) -> RenderableText { styled(font: .bold, color: color, size: 18) }
	func heading5(color: UIColor = .textColor) -> RenderableText { styled(font: .bold, color: color, size: 14) }
	func heading6(color: UIColor = .textColor) -> RenderableText { styled(font: .bold, color: color, size: 12) }
	func body1Bold(color: UIColor = .textColor) -> RenderableText { styled(font: .bold, color: color, size: 16) }
	func body1Medium(color: UIColor = .textColor) -> RenderableText { styled(font: .medium, color: color, size: 16) }
	func body1Regular(color: UIColor = .textColor) -> RenderableText { styled(font: .regular, color: color, size: 16) }
	func body2Medium(color: UIColor = .textColor) -> RenderableText { styled(font: .medium, color: color, size: 14) }
	func body2Regular(color: UIColor = .textColor) -> RenderableText { styled(font: .regular, color: color, size: 14) }
	func body3Medium(color: UIColor = .textColor) -> RenderableText { styled(font: .medium, color: color, size: 12) }
	func body3Regular(color: UIColor = .textColor) -> RenderableText { styled(font: .regular, color: color, size: 12) }
	func bodySmallRegular(color: UIColor = .textColor) -> RenderableText { styled(font: .regular, color: color, size: 11) }
	func largeBodyRegular(color: UIColor = .textColor) -> RenderableText { styled(font: .regular, color: color, size: 16) }
	
	static var testProfileImage: String = "https://weathereport.mypinata.cloud/ipfs/QmZJ56QmQpXQJamofJJYbR5T1gQTxVMhN5uHYfhvAmdFr8/85.png"
	static var testBackdropImage: String = "https://ikzttp.mypinata.cloud/ipfs/QmYDvPAXtiJg7s8JdRBSLWdgSphQdac8j1YuQNNxcGE1hg/40.png"
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
	
	var attributedString: NSAttributedString {
		NSAttributedString(string: self)
	}
	
	func isValidURL() -> Bool { URL(string: self) == nil }
	
	func isImageURL() -> Bool { self.contains("jpg") || self.contains("png") }
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
	
	var attributedString: NSAttributedString { self }
}

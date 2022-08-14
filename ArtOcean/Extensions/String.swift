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
}

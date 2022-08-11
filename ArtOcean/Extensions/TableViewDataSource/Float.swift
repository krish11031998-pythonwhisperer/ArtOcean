//
//  Float.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 11/08/2022.
//

import Foundation
import UIKit

extension Float {
	
	func styled(font: CustomFonts, color: UIColor, size: CGFloat) -> RenderableText {
		String(format: "%.2f", self).styled(font: font, color: color, size: size)
	}
}

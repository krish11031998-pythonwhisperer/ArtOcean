//
//  CGRect.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 29/08/2022.
//

import Foundation
import UIKit

extension CGRect {
	
	func expand(edges: UIEdgeInsets)  -> CGRect {
		.init(origin: .init(x: minX - edges.left, y: minY - edges.top), size: .init(width: width + edges.left + edges.right, height: height + edges.top + edges.bottom))
	}
}

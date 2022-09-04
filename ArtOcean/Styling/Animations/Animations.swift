//
//  Animations.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 04/09/2022.
//

import Foundation
import UIKit

extension CGPoint {
	
	static func + (lhs: Self, rhs: Self) -> Self {
		.init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
}

extension CAAnimation {
	enum Path: String {
		case x
		case y
		case none = ""
	}
	
	enum Key: String {
		case position
		case opacity
	}
	
	static func basicAnimation(key: Key, path: Path = .none) -> CABasicAnimation {
		let animation = CABasicAnimation()
		animation.keyPath = path != .none ? "\(key.rawValue).\(path.rawValue)" : key.rawValue
		return animation
	}
}

extension CAAnimationGroup {
	
	static func groupAnimation(_ animations: [CABasicAnimation]) -> CAAnimationGroup {
		let group: CAAnimationGroup = .init()
		group.animations = animations
		group.duration = animations.map(\.duration).reduce(0, {max($0,$1)})
		return group
	}
}

extension CALayer {
	
	func animate(_ animation: Animation,position: CGPoint, completion: Callback? = nil) {
		CATransaction.begin()

		if let validCompletion = completion {
			CATransaction.setCompletionBlock { validCompletion() }
		}
		
		add(animation.data(self, position: position), forKey: "animation")
		CATransaction.commit()
	}
}

extension UIView {

	var position: CGPoint {
		.init(x: frame.origin.x + frame.width.half, y: frame.origin.y + frame.height.half)
	}
	
	func animate(_ animation: Animation, completion: Callback? = nil) {
		layer.animate(animation, position: position, completion: completion)
	}
}

enum Animation {
	case slideY(offset: CGFloat, isHidden: Bool)
}

extension Animation {
	func data(_ layer: CALayer, position: CGPoint, completion: Callback? = nil) -> CAAnimation {
		switch self {
		case .slideY(let offset, let isHidden):
			
			let from = position
			var to = position
			to.y += offset
			let finalOpacity: Float = isHidden ? 0 : 1
			
			let slide = CAAnimation.basicAnimation(key: .position, path: .y)
			slide.fromValue = from.y
			slide.toValue = to.y
			slide.duration = 0.25
			layer.position = to
			
			let fade = CAAnimation.basicAnimation(key: .opacity)
			fade.keyPath = "opacity"
			fade.fromValue = layer.opacity
			fade.toValue = finalOpacity
			fade.duration = 0.25
			layer.opacity = finalOpacity
			
			let group: CAAnimationGroup = .groupAnimation([slide, fade])
			
			return group
		}
	}
}





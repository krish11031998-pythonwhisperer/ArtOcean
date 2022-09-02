//
//  CustomBackButton.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

enum ButtonStyle {
	case rounded(CGFloat)
	case circle(CGSize)
	case original
	
	var cornerRadius : CGFloat {
		switch self {
		case .rounded(let radius):
			return radius
		case .circle(let size):
			return size.width * 0.5
		case .original:
			return 0
		}
	}
	
}


//MARK: - CustomImageButton
class CustomImageButton: UIButton {
	
	public var handler: (() -> Void)?
	let name: UIImage.Catalogue?
	var url: String?
	let systemName: String?
	let bg: Bool
	let bgColor: UIColor
	let buttonTintColor: UIColor
	let bordered: Bool
	private let rescaleFactor: CGFloat = 0.375
	var buttonStyle: ButtonStyle
	
	var buttonBackgroundColor: UIColor = .clear {
		didSet { setupButton() }
	}
	
	public var hideButton: Bool {
		get { isHidden }
		set {
			UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
				self.isHidden = newValue
				self.layoutIfNeeded()
			}
		}
	}
	
	init(
		name:UIImage.Catalogue?,
		systemName:String?,
		url:String?,
		frame:CGSize,
		addBG:Bool,
		tintColor: UIColor,
		bgColor: UIColor,
		bordered: Bool,
		buttonStyle: ButtonStyle = .original,
		handler: (() -> Void)?
	) {
		self.buttonStyle = buttonStyle
		self.name = name
		self.systemName = systemName
		self.handler = handler
		self.bg = addBG
		self.buttonTintColor = tintColor
		self.bgColor = bgColor
		self.bordered = bordered
		self.buttonStyle = buttonStyle
		super.init(frame: .init(origin: .zero, size: frame))
		setupButton()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	convenience init(
		name:UIImage.Catalogue?,
		frame:CGSize = .squared(32),
		addBG: Bool = true,
		tintColor: UIColor = .surfaceBackgroundInverse,
		bgColor: UIColor = .surfaceBackground,
		bordered: Bool = true,
		buttonStyle: ButtonStyle = .original,
		handler:(() -> Void)? = nil) {
			self.init(name: name, systemName: nil,url: nil, frame: frame, addBG: addBG,tintColor: tintColor,bgColor: bgColor,bordered: bordered, buttonStyle: buttonStyle, handler: handler)
	}
	
	convenience init(
		systemName:String?,
		frame:CGSize = .squared(32),
		addBG: Bool = true,
		tintColor: UIColor = .surfaceBackgroundInverse,
		bgColor: UIColor = .surfaceBackground,
		bordered: Bool = true,
		buttonStyle: ButtonStyle = .original,
		handler:(() -> Void)? = nil) {
			self.init(name: nil, systemName: systemName,url: nil, frame: frame, addBG: addBG,tintColor: tintColor,bgColor: bgColor,bordered: bordered, buttonStyle: buttonStyle, handler: handler)
	}
	
	convenience init(
		url:String?,
		frame:CGSize = .squared(32),
		addBG: Bool = true,
		tintColor: UIColor = .surfaceBackgroundInverse,
		bgColor: UIColor = .surfaceBackground,
		bordered: Bool = true,
		buttonStyle: ButtonStyle = .original,
		handler:(() -> Void)? = nil) {
			self.init(name: nil, systemName: nil,url: url, frame: frame, addBG: addBG,tintColor: tintColor,bgColor: bgColor,bordered: bordered, buttonStyle: buttonStyle, handler: handler)
	}
	
	override var isSelected: Bool {
		willSet {
			UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
				self.transform = .init(scaleX: 0.9, y: 0.9)
			}
		}
	}
	
	func setupButton() {
		if let image = setupButtonImage() {
			setImage(image, for: .normal)
			setBackgroundImage(.solid(color: .clear), for: .normal)
			setBackgroundImage(.solid(color: .clear), for: .selected)
			cornerRadius = buttonStyle.cornerRadius
		}
		self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
	}
	
	@objc func handleTap() {
		handler?()
	}
	
	private var img: UIImage? {
		if let validName = name {
			return .buildCatalogueImage(name: validName, size: frame.size * rescaleFactor)
		} else if let validSystemName = systemName {
			return .init(systemName: validSystemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold))?
				.resized(frame.size * rescaleFactor)
		} else {
			return nil
		}
	}
	
	func setupButtonImage() -> UIImage? {
		let imageView = UIImageView(frame: frame)
		imageView.contentMode = .center
		if bg {
			imageView.backgroundColor = bgColor
		}
		
		if bordered {
			imageView.bordered(cornerRadius: frame.width.half, borderWidth: 1, borderColor: .appGrayColor)
		}
		
		imageView.image = img?.withTintColor(buttonTintColor)
		return imageView.snapshot
	}
	
	static func backButton(handler: @escaping () -> Void) -> CustomImageButton {
		let button: CustomImageButton = .init(name: .chevronLeft, frame: .squared(32), handler: handler)
		return button
	}
	
	static func closeButton(handler: @escaping () -> Void) -> CustomImageButton {
		let button: CustomImageButton = .init(name: .xMark, frame: .squared(32), handler: handler)
		return button
	}
	
	static var closeButton: CustomImageButton = .init(systemName: "chevron.left", frame: .squared(32), handler: nil)
	
}

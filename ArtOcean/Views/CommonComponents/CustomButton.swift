//
//  CustomBackButton.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 30/05/2022.
//

import Foundation
import UIKit

class CustomButton:UIView{
    
    public var handler:(() -> Void)?
    
    static var backButton:CustomButton = .init(systemName: "chevron.left")
    static var plusButton:CustomButton = .init(frame: .init(origin: .zero, size: .init(width: 28, height: 28)),name:"plus",autolayout: true)
    static var minusButton:CustomButton = .init(frame: .init(origin: .zero, size: .init(width: 28, height: 28)),name: "minus",autolayout: true)
    static var ethButton:CustomButton = .init(frame: .init(origin: .zero, size: .init(width: 28, height: 28)),name: "eth",autolayout: true)
    
    init(
		frame:CGRect = .init(origin: .zero, size: .init(width:30,height:30)),
		cornerRadius:CGFloat = 15,
		systemName:String? = nil,
		name:String? = nil,
		handler:(() -> Void)? = nil,
		autolayout:Bool = false
	){
        
        self.handler = handler
        
        super.init(frame: frame)
        
        self.setupView(cornerRadius: cornerRadius)
        
        self.buttonViewBuilder(systemName: systemName, name: name)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlerSelector)))
		setFrameConstraints(size: frame.size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func buttonViewBuilder(systemName:String?,name:String?){
        let buttonView = UIImageView()
        if let safeSystemName = systemName{
            buttonView.image = .init(systemName: safeSystemName,withConfiguration:UIImage.SymbolConfiguration(pointSize: 12, weight: .bold))
        }else if let safeName = name{
			buttonView.image = .init(named: safeName)
            buttonView.contentMode = .scaleAspectFit
        }
        
        buttonView.tintColor = .appBlackColor
		addSubview(buttonView)
		setCentralizedChild(buttonView)
    }
    
    func setupView(cornerRadius:CGFloat){
        self.layer.borderColor = UIColor.appGrayColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = .appWhiteBackgroundColor
        
    }
    
    @objc func handlerSelector(){
		print("(DEBUG) Clicked on the button")
        self.handler?()
    }
    
}


//MARK: - CustomImageButton
class CustomImageButton: UIButton {
	
	public var handler: (() -> Void)?
	let name: String?
	var url: String?
	let systemName: String?
	let bg: Bool
	private let rescaleFactor: CGFloat = 0.375
	
	init(name:String?,systemName:String?,url:String?,frame:CGSize,addBG:Bool, handler: (() -> Void)? ) {
		self.name = name
		self.systemName = systemName
		self.handler = handler
		self.bg = addBG
		super.init(frame: .init(origin: .zero, size: frame))
		setupButton()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	convenience init(name:String?,frame:CGSize = .squared(32),addBG: Bool = false,handler:(() -> Void)?) {
		self.init(name: name, systemName: nil,url: nil, frame: frame, addBG: addBG, handler: handler)
	}
	
	convenience init(systemName:String?,frame:CGSize = .squared(32),addBG: Bool = false,handler:(() -> Void)?) {
		self.init(name: nil, systemName: systemName,url: nil, frame: frame, addBG: addBG, handler: handler)
	}
	
	convenience init(url:String?,frame:CGSize = .squared(32),addBG: Bool = false,handler:(() -> Void)?) {
		self.init(name: nil, systemName: nil,url: url, frame: frame, addBG: addBG, handler: handler)
	}
	
	func setupButton() {
		if let image = setupButtonImage() {
			setImage(image, for: .normal)
		}
		self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
	}
	
	@objc func handleTap() {
		handler?()
	}
	
	private var img: UIImage? {
		if let validName = name {
			return .init(named: validName)?.resized(frame.size * rescaleFactor)
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
			imageView.backgroundColor = .white
		}
		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.appGrayColor.cgColor
		imageView.layer.cornerRadius = frame.width.half()
		imageView.image = img?.withTintColor(.appPurpleColor)
		return imageView.snapshot
	}
	
	static func closeButton(handler: @escaping () -> Void) -> CustomImageButton {
		let button: CustomImageButton = .init(name: "chevron-left", frame: .squared(32), handler: handler)
		return button
	}
	
	static var closeButton: CustomImageButton = .init(systemName: "chevron.left", frame: .squared(32), handler: nil)
	
}

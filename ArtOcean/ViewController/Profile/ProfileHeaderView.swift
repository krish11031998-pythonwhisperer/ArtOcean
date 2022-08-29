//
//  ProfileHeaderView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 11/07/2022.
//

import Foundation
import UIKit

fileprivate extension UIView {
	static func buttonBuilder(_ buttonName:UIImage.Catalogue, _ buttonTitle:String, handler: @escaping () -> Void) -> UIView {
		let button = CustomImageButton(name: buttonName, frame: .squared(40), addBG: true, handler: nil)
		let label = CustomLabel(text: buttonTitle, size: 12, weight: .medium, color: .gray,numOfLines: 1,adjustFontSize: false)
		label.textAlignment = .center
		let stack = UIStackView(arrangedSubviews: [button,label])
		stack.axis = .vertical
		stack.spacing = 12
		stack.distribution = .fill
		stack.alignment = .center
		stack.accessibilityIdentifier = buttonTitle
		button.handler = handler
		return stack
	}
}

protocol ProfileHeaderEventDelegate {
	func clickedOnProfileButton(_ identifier: String)
}


class ProfileHeaderView:UIView {
	
	public var delegate:ProfileHeaderEventDelegate?
	
	private let name:UILabel = CustomLabel(text: "Krishna Venkat", size: 18, weight: .bold, color: .black)
	
	private let username:UILabel = CustomLabel(text: "@cryptoPython", size: 14, weight: .medium, color: .gray)
	
	private let profileHeader:UILabel =  CustomLabel(text: "Profile", size: 22, weight: .bold, color: .white)
	
	private let settingButton:UIView = { CustomImageButton(name: .userOutline, frame: .squared(40), addBG: true, handler: nil) }()
	
	private lazy var buttons: [UIView] = {
		[(UIImage.Catalogue.heartOutline,"Favorites"),
		 (UIImage.Catalogue.creditCardOutline, "Wallet"),
		 (UIImage.Catalogue.pencil, "Draft"),
		 (UIImage.Catalogue.userOutline, "Profile")
		].map { (img,title) in .buttonBuilder(img, title) { [weak self] in self?.delegate?.clickedOnProfileButton(title)} }

	}()
	
	
	private lazy var mainStack: UIStackView = {
		.VStack(aligmment: .center)
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		setupTopHeaderView()
		userProfileView()
		profileOptionsView()
//		mainStack.addArrangedSubview(.spacer())
		addViewAndSetConstraints(mainStack, edgeInsets: .zero)
		
	}
	
//MARK: - Protected Methods
	
	private let userProfileImageView:UIImageView = {
		let view = CustomImageView(cornerRadius: 32)
		view.updateImageView(url: "https://weathereport.mypinata.cloud/ipfs/QmZJ56QmQpXQJamofJJYbR5T1gQTxVMhN5uHYfhvAmdFr8/85.png")
		view.setWidthWithPriority(64, priority: .defaultHigh)
		view.setHeightWithPriority(64, priority: .required)
		return view
	}()

	private func userProfileView() {
		let stack: UIStackView = .init(arrangedSubviews: [userProfileImageView,name,username])
		stack.axis = .vertical
		stack.spacing = 4
		stack.alignment = .center
//		stack.compressVerticalFit()
		stack.setCustomSpacing(16, after: userProfileImageView)
		mainStack.addArrangedSubview(stack)
		mainStack.setCustomSpacing(32, after: stack)
	}
	
	private func setupTopHeaderView() {
		let stack: UIStackView = .init(arrangedSubviews: [profileHeader,.spacer(),settingButton])
//		stack.compressVerticalFit()
		mainStack.addArrangedSubview(stack)
		mainStack.setHorizontalConstraintsToChild(stack, edgeInsets: .init(vertical: .zero, horizontal: 20), withPriority: 999)
		mainStack.setCustomSpacing(46, after: stack)
	}
	
	private func profileOptionsView() {
		let stack = UIStackView(arrangedSubviews: buttons)
		stack.alignment = .center
		stack.distribution = .fillEqually
		stack.spacing = 0
//		stack.compressVerticalFit()
		mainStack.addArrangedSubview(stack)
		mainStack.setHorizontalConstraintsToChild(stack, edgeInsets: .init(vertical: .zero, horizontal: 20), withPriority: 999)
	}
}

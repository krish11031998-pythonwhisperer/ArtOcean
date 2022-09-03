//
//  ProfileHeaderView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 11/07/2022.
//

import Foundation
import UIKit

protocol ProfileHeaderEventDelegate {
	func clickedOnProfileButton(_ identifier: String)
}

struct ProfileButton {
	var imageName: UIImage.Catalogue
	var name: String
	
	init(imageName: UIImage.Catalogue, name: String) {
		self.imageName = imageName
		self.name = name
	}
	
	func buildView(handler: @escaping () -> Void) -> UIView {
		let button = CustomImageButton(name: imageName, frame: .squared(40), addBG: true, handler: handler)
		let label =  CustomLabel(text: name, size: 12, weight: .medium, color: .gray,numOfLines: 1,adjustFontSize: false)
		label.textAlignment = .center
		let stack = UIStackView(arrangedSubviews: [button,label])
		stack.axis = .vertical
		stack.spacing = 12
		stack.distribution = .fill
		stack.alignment = .center
		return stack.embedInView(edges: .init(vertical: 0, horizontal: 10), priority: .needed)
	}
}

class ProfileHeaderView:UIView {
	
	public var delegate:ProfileHeaderEventDelegate?
	
	private let name:UILabel = .init()
	
	private let username:UILabel = .init()
	
	private let profileHeader:UILabel = .init()
	
	private let profileButtons: [ProfileButton] = [
		.init(imageName: .heartOutline, name: "Favorites"),
		.init(imageName: .creditCardOutline, name: "Wallet"),
		.init(imageName: .pencil, name: "Draft"),
		.init(imageName: .userOutline, name: "Profile")
	]
	
	private lazy var buttons: [UIView] = {
		profileButtons.map { button in button.buildView { [weak self] in self?.delegate?.clickedOnProfileButton(button.name)  } }
	}()
	
	
	private lazy var mainStack: UIStackView = { .VStack(aligmment: .center) }()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setupView() {
		setupTopHeaderView()
		userProfileView()
		profileOptionsView()
		addViewAndSetConstraints(mainStack, edgeInsets: .zero)
		updateHeader()
	}

//MARK: - Overriden Methods
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		mainStack.removeAllSubViews()
		setupView()
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
		stack.setCustomSpacing(16, after: userProfileImageView)
		mainStack.addArrangedSubview(stack)
		mainStack.setCustomSpacing(32, after: stack)
	}
	
	private func setupTopHeaderView() {
		let settingButton = CustomImageButton(name: .userOutline, frame: .squared(40), addBG: true, handler: nil)
		let stack: UIStackView = .init(arrangedSubviews: [profileHeader,.spacer(),settingButton])
		settingButton.setFrameConstraints(size: .squared(40), withPriority: .defaultHigh)
		stack.setHeightWithPriority(stack.compressedFittingSize.height)
		mainStack.addArrangedSubview(stack)
		mainStack.setHorizontalConstraintsToChild(stack, edgeInsets: .init(vertical: .zero, horizontal: 20), withPriority: 999)
		mainStack.setCustomSpacing(46, after: stack)
	}
	
	private func profileOptionsView() {
		let arrangedViews = profileButtons.map { button in button.buildView { [weak self] in self?.delegate?.clickedOnProfileButton(button.name)  } }
		let stack = UIStackView(arrangedSubviews: arrangedViews)
		stack.alignment = .center
		stack.distribution = .fill
		stack.spacing = 0
		mainStack.addArrangedSubview(stack)
	}

//MARK: - Exposed Methods
	
	public func updateHeader() {
		"Krishna Venkat".heading4().renderInto(target: name)
		"@cryptoPython".body2Medium().renderInto(target: username)
		"Profile".heading3().renderInto(target: profileHeader)
	}
	
}

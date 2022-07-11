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


class ProfileHeaderView:UIView {
	
	public var delegate:ProfileHeaderEventDelegate?
	
	private let name:UILabel = CustomLabel(text: "Krishna Venkat", size: 18, weight: .bold, color: .black)
	
	private let username:UILabel = CustomLabel(text: "@cryptoPython", size: 14, weight: .medium, color: .gray)
	
	private let profileHeader:UILabel =  CustomLabel(text: "Profile", size: 22, weight: .bold, color: .white)
	
	private let settingButton:UIView = { CustomButton(frame: .init(origin: .zero, size: .squared(40)),cornerRadius: 20, name: "settings", handler: nil) }()
	
	private lazy var favoriteButton:UIView = { buttonBuilder("favorites", "Favorites") }()
	
	private lazy var walletButton:UIView = { buttonBuilder("wallet", "Wallet") }()
	
	private lazy var draftButton:UIView = { buttonBuilder("draft", "Draft") }()
	
	private lazy var profileButton:UIView = { buttonBuilder("profile", "Profile") }()
	
	private lazy var mainStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [.spacer(height: 56)])
		stack.axis = .vertical
		return stack
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		setupBackdrop()
		addViewAndSetConstraints(mainStack, edgeInsets: .zero)
		setupTopHeaderView()
		userProfileView()
		profileOptionsView()
	}
	
//MARK: - Protected Methods
	
	private func setupBackdrop() {
		let imageView = UIImageView(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 200)))
		imageView.image = .init(named: "userProfileDefaultbackground")
		imageView.blurGradientBackDrop(size: .init(width: UIScreen.main.bounds.width, height: 200))
		addSubview(imageView)
	}
	
	private let userProfileImageView:UIImageView = {
		let view = CustomImageView(named: "userProfileImage", cornerRadius: 32)
		view.setHeightWithPriority(64,priority: .required)
		view.setWidthWithPriority(64)
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
		let stack: UIStackView = .init(arrangedSubviews: [.spacer(width: 24),profileHeader,.spacer(),settingButton,.spacer(width: 24)])
		mainStack.addArrangedSubview(stack)
		mainStack.setCustomSpacing(46, after: stack)
	}
	
	private func buttonBuilder(_ buttonName:String, _ buttonTitle:String) -> UIView {
		let button = CustomButton(frame: .init(origin: .zero, size: .squared(40)),cornerRadius: 20, name: buttonName)
		let label = CustomLabel(text: buttonTitle, size: 12, weight: .medium, color: .gray,numOfLines: 1,adjustFontSize: false)
		label.textAlignment = .center
		let stack = UIStackView(arrangedSubviews: [button,label])
		stack.axis = .vertical
		stack.spacing = 5
		stack.alignment = .center
		button.setWidthWithPriority(40, priority: .defaultHigh)
		label.setContentCompressionResistancePriority(.required, for: .horizontal)
		stack.accessibilityIdentifier = buttonTitle
		button.handler = { [weak self] in self?.delegate?.clickedOnProfileButton(buttonTitle) }
		return stack
	}
	
	private func profileOptionsView() {
		let stack = UIStackView(arrangedSubviews: [.spacer(width:50),favoriteButton,.spacer(),profileButton,.spacer(),walletButton,.spacer(),draftButton,.spacer(width: 50)])
		stack.alignment = .center
		stack.spacing = 10
		let availableWidth = UIScreen.main.bounds.width - 100
		let viewWidth = availableWidth/CGFloat(stack.arrangedSubviews.count) - stack.spacing * 0.5
		
		stack.arrangedSubviews.forEach { $0.setWidthWithPriority(viewWidth, priority: .defaultHigh) }
		mainStack.addArrangedSubview(stack)
//		mainStack.addArrangedSubview(.spacer())
	}
}

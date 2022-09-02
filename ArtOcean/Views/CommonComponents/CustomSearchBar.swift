//
//  CustomSearchBar.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 26/06/2022.
//

import Foundation
import UIKit

protocol CustomSearchBarDelegate{
	func searchWithFilter(_ word:String)
}

class CustomSearchBar:UIView {
	
	public var delegate:CustomSearchBarDelegate? = nil
	
	private var textField: UITextField = {
		let textField = UITextField()
		textField.backgroundColor = .clear
		textField.attributedPlaceholder = NSAttributedString(string: "Search For Items", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appGrayColor,NSAttributedString.Key.font : UIFont(name: "Satoshi-Medium", size: 14)!])
		textField.font = UIFont(name: "Satoshi-Medium", size: 14)!
		textField.textColor = .textColor
		textField.setContentHuggingPriority(.init(249), for: .horizontal)
		textField.setContentCompressionResistancePriority(.init(749), for: .horizontal)
		return textField
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupUI(){
		let stack = UIStackView()
		stack.spacing = 18.5
		
		textField.delegate = self
		
		let imageView = UIImageView(frame: .init(origin: .zero, size: .smallestSqaure))
		imageView.image = .Catalogue.searchOutline.image.withTintColor(.surfaceBackgroundInverse)
		imageView.contentMode = .scaleAspectFit
		stack.addArrangedSubview(imageView)
		stack.addArrangedSubview(textField)
		
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = .init(vertical: 10, horizontal: 10)
		stack.bordered(borderColor: .surfaceBackgroundInverse)
		addSubview(stack)
		
		setConstraintsToChild(stack, edgeInsets: .init(top: 0, left: 10, bottom: 0, right: 10))
	}
	
	override var intrinsicContentSize: CGSize{
		return .init(width: UIScreen.main.bounds.width, height: 55)
	}
	
	public func showDismissKeyboard() {
		textField.resignFirstResponder()
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		removeAllSubViews()
		setupUI()
	}
}

//MARK: - TextField Delegate
extension CustomSearchBar:UITextFieldDelegate{
	func textFieldDidChangeSelection(_ textField: UITextField) {
		guard let searchedText = textField.text else {return}
		delegate?.searchWithFilter(searchedText)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
}

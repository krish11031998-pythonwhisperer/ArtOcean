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

class CustomSearchBar:UIView{
	
	public var delegate:CustomSearchBarDelegate? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupUI(){
		let view = UIStackView()
		view.spacing = 18.5
		
		let textField = UITextField()
		textField.delegate = self
		textField.backgroundColor = .clear
		textField.attributedPlaceholder = NSAttributedString(string: "Search For Items", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appGrayColor,NSAttributedString.Key.font : UIFont(name: "Satoshi-Medium", size: 14)!])
		textField.font = UIFont(name: "Satoshi-Medium", size: 14)!
		textField.textColor = .black
		textField.setContentHuggingPriority(.init(249), for: .horizontal)
		textField.setContentCompressionResistancePriority(.init(749), for: .horizontal)
		textField.layer.cornerRadius = 12
		
		let imageView = UIImageView()
		imageView.image = .init(named: "search")
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFit
		
		view.addArrangedSubview(imageView)
		view.addArrangedSubview(textField)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.borderColor = UIColor.appGrayColor.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 12
		view.isLayoutMarginsRelativeArrangement = true
		view.layoutMargins = .init(top: 10, left: 25, bottom: 10, right: 25)
		
		addSubview(view)
		
		setContraintsToChild(view, edgeInsets: .init(top: 0, left: 10, bottom: 0, right: -10))
	}
	
	override var intrinsicContentSize: CGSize{
		return .init(width: UIScreen.main.bounds.width, height: 55)
	}
	
}

//MARK: - TextField Delegate
extension CustomSearchBar:UITextFieldDelegate{
	func textFieldDidChangeSelection(_ textField: UITextField) {
		guard let searchedText = textField.text else {return}
		delegate?.searchWithFilter(searchedText)
	}
}

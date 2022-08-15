//
//  NFTLiveBidNavHeader.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 02/08/2022.
//

import Foundation
import UIKit

class NFTDetailNavHeader: UIView {
	
	private lazy var imageView: UIImageView = {
		let view = UIImageView(frame: .init(origin: .zero, size: .squared(32)))
		view.contentMode = .scaleAspectFill
		view.cornerRadius = 4
		view.clipsToBounds = true
		return view
	}()
	
	private lazy var titleView: UILabel = {
		let label = CustomLabel(text: "", size: 18, weight: .bold, color: .appBlackColor, numOfLines: 1)
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		buildUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		buildUI()
	}
	
//MARK: - Protected Methods
	
	private func buildUI() {
		let stack = UIStackView(arrangedSubviews: [imageView,titleView])
		stack.spacing = 8
		addSubview(stack)
		imageView.setWidthWithPriority(32)
		stack.setHeightWithPriority(32)
		setConstraintsToChild(stack, edgeInsets: .zero)
	}

//MARK: -  Exposed Methods
	
	public func configureHeader(imageUrl: String? = nil, title: String) {
		imageView.updateImageView(url: imageUrl)
		titleView.text = title
		imageView.transform = .init(scaleX: .zero, y: .zero)
	}
	
	public func animateIn(offset: CGFloat) {
		let scale: CGFloat = offset != .zero ? .zero : 1
		UIView.animate(withDuration: 0.25, delay: 0.3) {
			self.imageView.transform = .init(scaleX: scale, y: scale)
		}
	}
}

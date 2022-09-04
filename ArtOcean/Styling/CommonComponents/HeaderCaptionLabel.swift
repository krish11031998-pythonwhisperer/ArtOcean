//
//  HeaderCaptionLabel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 08/08/2022.
//

import Foundation
import UIKit

class HeaderCaptionLabel: UIView {
	
	private lazy var leadingTopLabel: UILabel = { .init() }()
	
	private lazy var trailingTopLabel: UILabel = { .init() }()
	
	private lazy var leadingBottomLabel: UILabel = { .init() }()
	
	private lazy var trailingBottomLabel: UILabel = { .init() }()
	
	private var imageView: UIImageView?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.alignment = .center
		stack.spacing = 12
		return stack
	}()
	
	private func leadingStack(title: RenderableText? = nil, subTitle: RenderableText? = nil) -> UIStackView? {
		
		guard title != nil, subTitle != nil else { return nil }
		
		let leadingStack: UIStackView = .init()
		leadingStack.axis = .vertical
		leadingStack.spacing = 10
		
		if let validTitle = title {
			validTitle.renderInto(target: leadingTopLabel)
			leadingStack.addArrangedSubview(leadingTopLabel)
		} else {
			leadingTopLabel.isHidden = true
		}
		
		if let validSubtitle = subTitle {
			validSubtitle.renderInto(target: leadingBottomLabel)
			leadingStack.addArrangedSubview(leadingBottomLabel)
		} else {
			leadingBottomLabel.isHidden = true
		}
		
		return leadingStack
	}
	
	private func trailingStack(info: RenderableText? = nil, footer: RenderableText? = nil) -> UIStackView? {
		
		guard info != nil, footer != nil else { return nil }
		
		let trailingStack: UIStackView = .init()
		trailingStack.axis = .vertical
		trailingStack.spacing = 10
		
		if let validTitle = info {
			validTitle.renderInto(target: trailingTopLabel)
			trailingStack.addArrangedSubview(trailingTopLabel)
		} else {
			trailingTopLabel.isHidden = true
		}
		
		if let validSubtitle = footer {
			validSubtitle.renderInto(target: trailingBottomLabel)
			trailingStack.addArrangedSubview(trailingBottomLabel)
		} else {
			trailingBottomLabel.isHidden = true
		}
		
		return trailingStack
	}
	
	public func configureLabel(
		img: UIImage? = nil,
		title: RenderableText? = nil,
		subTitle: RenderableText? = nil,
		info: RenderableText? = nil,
		footer: RenderableText? = nil
	) {
		if let img = img {
			imageView = CustomImageView(cornerRadius: 32)
			imageView?.image = img
			imageView?.setFrameConstraints(size: .squared(64))
		}
		
		let views = [imageView,leadingStack(title: title, subTitle: subTitle),trailingStack(info: info, footer: footer)]
		views.compactMap { $0 }.forEach {
			mainStack.addArrangedSubview($0)
		}
		
		addSubview(mainStack)
		mainStack.setConstraintsWithParent(edgeInsets: .zero,withPriority: .init(rawValue: 999))
		//setConstraintsToChild(mainStack, edgeInsets: .init(vertical: 0, horizontal: 10),withPriority: 999)
	}
	
}

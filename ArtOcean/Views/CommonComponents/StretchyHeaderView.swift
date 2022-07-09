//
//  StretchyHeaderView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 05/06/2022.
//

import Foundation
import UIKit

class StreachyHeaderView:UIView{
    
    private var viewHeightConstraint:NSLayoutConstraint? = nil
    private var viewTopConstraint:NSLayoutConstraint? = nil
    private var height:CGFloat
    private let innerView:UIView
    
	init(width:CGFloat = UIScreen.main.bounds.width,height:CGFloat,innerView:UIView){
        self.height = height
        self.innerView = innerView
        self.innerView.clipsToBounds = true
		super.init(frame: .init(origin: .zero, size: .init(width: width, height: height)))
		autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addSubview(innerView)
        layer.addSublayer(gradient)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = frame
    }
    private var gradient:CAGradientLayer = {
       let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear,UIColor.white.withAlphaComponent(0.2).cgColor,UIColor.white.withAlphaComponent(0.6).cgColor,UIColor.white.withAlphaComponent(1).cgColor]
        return gradient
    }()
    
    func setupLayout(){
        innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        viewTopConstraint = innerView.topAnchor.constraint(equalTo: self.topAnchor)
        viewTopConstraint?.isActive = true
        innerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        viewHeightConstraint =  innerView.heightAnchor.constraint(equalToConstant: height)
        viewHeightConstraint?.isActive = true
    }
    
    
    //MARK: - StretchOnScroll
    
    public func StretchOnScroll(_ scrollView:UIScrollView) -> CGFloat {
		let y_offset = scrollView.contentOffset.y

        if y_offset < 0{
			let computedHeight = max(height - y_offset,height)
            viewHeightConstraint?.constant = computedHeight
			return computedHeight
        }
        return height
    }
}

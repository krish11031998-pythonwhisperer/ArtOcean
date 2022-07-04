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
    
    init(height:CGFloat,innerView:UIView){
        self.height = height
        self.innerView = innerView
        self.innerView.clipsToBounds = true
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(innerView)
        self.layer.addSublayer(self.gradient)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient.frame = self.frame
    }
    private var gradient:CAGradientLayer = {
       let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear,UIColor.white.withAlphaComponent(0.2).cgColor,UIColor.white.withAlphaComponent(0.6).cgColor,UIColor.white.withAlphaComponent(1).cgColor]
        return gradient
    }()
    
    func setupLayout(){
        self.innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.viewTopConstraint = self.innerView.topAnchor.constraint(equalTo: self.topAnchor)
        self.viewTopConstraint?.isActive = true
        self.innerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.viewHeightConstraint =  self.innerView.heightAnchor.constraint(equalToConstant: height)
        self.viewHeightConstraint?.isActive = true
    
    }
    
    
    //MARK: - StretchOnScroll
    
    public func StretchOnScroll(_ scrollView:UIScrollView){
		let y_offset = scrollView.contentOffset.y

        if y_offset < 0{
            self.viewTopConstraint?.constant = y_offset - 10
            self.viewHeightConstraint?.constant = max(self.height - y_offset,height)
        }
        
    }
}

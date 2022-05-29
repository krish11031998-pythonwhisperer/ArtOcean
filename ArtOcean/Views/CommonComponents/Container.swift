//
//  Container.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/05/2022.
//

import UIKit

class Container: UIView {

    private var headerView:ContainerHeaderView? = nil
    private var includeHeader:Bool = false
    private var innerView:UIView = UIView()
    private var innerViewSize:CGSize = .zero
    private var addInnerViewPadding:Bool
    
    init(
        header:String,
        rightButtonTitle:String,
        innerView:UIView,
        innerViewSize:CGSize,
        buttonHandler: @escaping (() -> Void)
    ){
        self.addInnerViewPadding = false
        super.init(frame: .zero)
        self.headerView = ContainerHeaderView(title: header, rightButtonTitle: rightButtonTitle, buttonHandler: buttonHandler)
        self.innerView = innerView
        self.innerViewSize = innerViewSize
        self.setupViews()
        self.setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let safeHeaderView = self.headerView{
            self.addSubview(safeHeaderView)
        }
        
        self.addSubview(self.innerView)
    }
    
    func setupLayout(){
        
        if let safeHeaderView = self.headerView{
            safeHeaderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            safeHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10).isActive = true
            safeHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10).isActive = true
            self.innerView.topAnchor.constraint(equalTo: safeHeaderView.bottomAnchor, constant: 5).isActive = true
            self.innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            self.innerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            self.innerView.widthAnchor.constraint(equalToConstant: self.innerViewSize.width).isActive = true
            self.innerView.heightAnchor.constraint(equalToConstant: self.innerViewSize.height).isActive = true
        }else{
            self.innerView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            self.innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            self.innerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            self.innerView.widthAnchor.constraint(equalToConstant: self.innerViewSize.width).isActive = true
            self.innerView.heightAnchor.constraint(equalToConstant: self.innerViewSize.height).isActive = true
        }
    }
        
    override var intrinsicContentSize: CGSize{
        return .init(width: self.innerViewSize.width, height: (self.headerView?.intrinsicContentSize.height ?? 0) + self.innerViewSize.height + 5)
    }
    
}

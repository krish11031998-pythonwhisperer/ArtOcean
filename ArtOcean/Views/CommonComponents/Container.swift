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
    private var paddingToHeaderView:Bool
    private var padding:CGFloat
    
    init(
        header:String,
        rightButtonTitle:String,
        innerView:UIView,
        innerViewSize:CGSize,
        paddingToHeaderView:Bool = true,
        padding:CGFloat = 8,
        buttonHandler: @escaping (() -> Void)
    ){
        self.addInnerViewPadding = false
        self.paddingToHeaderView = paddingToHeaderView
        self.padding = padding
        super.init(frame: .zero)
        self.headerView = ContainerHeaderView(title: header, rightButtonTitle: rightButtonTitle, buttonHandler: buttonHandler)
        self.innerView = innerView
        self.innerViewSize = innerViewSize
        self.setupViews()
        self.setupLayout()
    }
    
    init(
        innerView:UIView,
        innerViewSize:CGSize
    ){
        self.addInnerViewPadding = false
        self.paddingToHeaderView = false
        self.padding = .zero
        super.init(frame: .zero)
        self.innerView = innerView
        self.innerViewSize = innerViewSize
        self.setupViews()
        self.setupLayout()
    }
    
    init(
        innerView:UIView
    ){
        self.addInnerViewPadding = false
        self.paddingToHeaderView = false
        self.padding = .zero
        super.init(frame: .zero)
        self.innerView = innerView
        self.innerViewSize = .zero
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
            safeHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: self.paddingToHeaderView ? padding : 0).isActive = true
            safeHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: self.paddingToHeaderView ? -padding : 0).isActive = true
        }
        
        self.innerView.topAnchor.constraint(equalTo: headerView?.bottomAnchor ?? self.topAnchor, constant: headerView == nil ? 0 : 12).isActive = true
        self.innerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        if self.innerViewSize.width == .zero{
            self.innerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            self.innerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }else{
            self.innerView.widthAnchor.constraint(equalToConstant: self.innerViewSize.width).isActive = true
        }
        self.innerView.heightAnchor.constraint(equalToConstant: self.innerViewSize.height).isActive = true
        
    }
        
    override var intrinsicContentSize: CGSize{
        return .init(width: self.innerViewSize.width, height: (self.headerView?.intrinsicContentSize.height ?? 0) + self.innerViewSize.height + 5)
    }
    
}

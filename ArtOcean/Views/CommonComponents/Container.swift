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
    
    init(
        header:String,
        rightButtonTitle:String,
        innerView:UIView,
        innerViewSize:CGSize,
        buttonHandler: @escaping (() -> Void)
    ){
        super.init(frame: .zero)
        self.headerView = ContainerHeaderView(title: header, rightButtonTitle: rightButtonTitle, buttonHandler: buttonHandler)
        self.innerView = innerView
        self.innerViewSize = innerViewSize
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupViews(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let safeHeaderView = self.headerView{
            self.addSubview(safeHeaderView)
            self.configHeader()
        }
        
        self.addSubview(self.innerView)
        self.configInnerView()
    }
    
    func configHeader(){
        guard let safeHeaderView = self.headerView else {return}
        safeHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10).isActive = true
        safeHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        safeHeaderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }

    func configInnerView(){
        //leadingAnchor
        self.innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        //topAnchor
        if let safeHeaderView = self.headerView{
            self.innerView.topAnchor.constraint(equalTo: safeHeaderView.bottomAnchor,constant: 16).isActive = true
        }else{
            self.innerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
        //heightAnchor
        self.innerView.heightAnchor.constraint(equalToConstant: self.innerViewSize.height).isActive = true
        self.innerView.widthAnchor.constraint(equalToConstant: self.innerViewSize.width).isActive = true
    }
    
}

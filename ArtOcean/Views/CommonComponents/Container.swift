//
//  Container.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 25/05/2022.
//

import UIKit

class Container: UIStackView {

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
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.spacing = 5
        
        if let safeHeaderView = self.headerView{
            self.addArrangedSubview(safeHeaderView)
        }
        
        self.addArrangedSubview(self.innerView)
        self.innerView.frame.size = self.innerViewSize
    }
    
}

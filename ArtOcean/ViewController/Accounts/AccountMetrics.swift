//
//  AccountMetrics.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 03/06/2022.
//

import Foundation
import UIKit

class AccoutnMetrics:UIView{
    
    private var userMetrics:[String:Any]
    
    init(metrics:[String:Any]){
        self.userMetrics = metrics
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.stackView)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    
    func metricStatBuilder(key:String,value:Any) -> UIStackView{
        let valueLabel = CustomLabel(text: "\(value)", size: 16, weight: .bold, color: .appBlackColor, numOfLines: 1, adjustFontSize: true)
        let keyLabel = CustomLabel(text: key, size: 12, weight: .medium, color: .appGrayColor, numOfLines: 1, adjustFontSize: true)
        
        valueLabel.textAlignment = .center
        keyLabel.textAlignment = .center
        
        let view = UIStackView.StackBuilder(views: [valueLabel,keyLabel], ratios: [0.5,0.5], spacing: 10, axis: .vertical)

        return view
        
    }
    
    private lazy var stackView:UIStackView = {
        let views = self.userMetrics.compactMap({self.metricStatBuilder(key: $0, value: $1)})
        let stack = UIView.StackBuilder(views: views, ratios: Array(repeating: CGFloat(1)/CGFloat(views.count), count: views.count), spacing: 10, axis: .horizontal)
        
        return stack
        
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupLayout(){
        self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}

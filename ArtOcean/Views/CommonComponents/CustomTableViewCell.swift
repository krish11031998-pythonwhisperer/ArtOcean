//
//  CustomTableViewCell.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 15/06/2022.
//

import Foundation
import UIKit

protocol CustomTableViewCellDelegate{
    func handleTap(_ data:Any?)
}

class CustomTableViewCell:UITableViewCell{
    
    var data:Any? = nil
    var celldelegate:CustomTableViewCellDelegate? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = .clearView()
        backgroundColor = .clear
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            bouncyButtonClick()
            celldelegate?.handleTap(data)
        }
    }
    
    public func configureCell(_ data:Any,view:UIView,leadingMultiple lead:CGFloat = 1,trailingMultiple trail:CGFloat = 1,topMultiple topM:CGFloat = 1,bottomMultiple bottomM:CGFloat = 1){
        self.data = data
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: lead),
            self.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor,multiplier: trail),
            view.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor,multiplier:topM),
            self.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor,multiplier:bottomM)
        ])
    }
}

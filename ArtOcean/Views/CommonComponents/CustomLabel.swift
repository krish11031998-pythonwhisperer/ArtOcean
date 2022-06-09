//
//  CustomLabel.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 01/06/2022.
//

import Foundation
import UIKit

class CustomLabel:UILabel{
    init(
        text:String,
        size:CGFloat = 13,
        weight:UIFont.Weight = .semibold,
        color:UIColor,
        numOfLines:Int,
        adjustFontSize:Bool = true,
        autoLayout:Bool = true
    ){
        super.init(frame: .zero)
        self.text = text
        switch weight{
            case .black:
            self.font = .init(name: "Satoshi-Black", size: size)
                break
            case .bold:
            self.font = .init(name: "Satoshi-Bold", size: size)
                break
            case .regular:
            self.font = .init(name: "Satoshi-Regular", size: size)
                break
            case .medium:
            self.font = .init(name: "Satoshi-Medium", size: size)
                break
            case .light:
            self.font = .init(name: "Satoshi-Light", size: size)
                break
            default:
            self.font = .systemFont(ofSize: size, weight: .light)
        }
        self.textColor = color
        self.numberOfLines = numOfLines
        self.adjustsFontSizeToFitWidth = adjustFontSize
        self.translatesAutoresizingMaskIntoConstraints = !autoLayout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

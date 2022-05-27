//
//  UIView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import Foundation
import UIKit


extension UIView{
    public func gradientLayerBuilder() -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        return gradient
    }
    
    public func imageView(cornerRadius:CGFloat = 10, borderColor:UIColor = .clear,borderWidth:CGFloat = 1,autoLayout:Bool = true,addGradient:Bool = false) -> UIImageView{
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = .init(named: "placeHolder")
        imageView.translatesAutoresizingMaskIntoConstraints = autoLayout
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderColor = borderColor.cgColor
        imageView.layer.borderWidth = borderWidth
        if addGradient{
            let gradient = self.gradientLayerBuilder()
            imageView.layer.addSublayer(gradient)
        }
        return imageView
    }
    
    public func labelBuilder(text:String,size:CGFloat = 13,weight:UIFont.Weight = .semibold,color:UIColor,numOfLines:Int) -> UILabel{
        let label = UILabel()
        label.text = text
        switch weight{
            case .black:
                label.font = .init(name: "Satoshi-Black", size: size)
                break
            case .bold:
                label.font = .init(name: "Satoshi-Bold", size: size)
                break
            case .regular:
                label.font = .init(name: "Satoshi-Regular", size: size)
                break
            case .medium:
                label.font = .init(name: "Satoshi-Medium", size: size)
                break
            case .light:
                label.font = .init(name: "Satoshi-Light", size: size)
                break
            default:
                label.font = .systemFont(ofSize: size, weight: .light)
        }
        label.textColor = color
        label.numberOfLines = numOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

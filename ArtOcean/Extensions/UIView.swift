//
//  UIView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import Foundation
import UIKit


extension UIView{
    
    static func clearView() -> UIView{
        let view = UIView()
        view.clearView()
        return view
    }
    
    public func gradientLayerBuilder() -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        return gradient
    }
    
    public func bouncyButtonClick(scaleDownTo:CGFloat = 0.95){
        DispatchQueue.main.async {
            UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                self.transform = CGAffineTransform.init(scaleX: scaleDownTo, y: scaleDownTo)
                self.layoutIfNeeded()
            }.startAnimation()
            
            UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.layoutIfNeeded()
            }.startAnimation(afterDelay: 0.2)
        }
    }
    
    public func clearView(){
        self.backgroundColor = .clear
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
    
    public func labelBuilder(text:String,size:CGFloat = 13,weight:UIFont.Weight = .semibold,color:UIColor,numOfLines:Int,adjustFontSize:Bool = true) -> UILabel{
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
        label.adjustsFontSizeToFitWidth = adjustFontSize
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func StackBuilder(views:[UIView],ratios:[CGFloat],spacing:CGFloat,axis:NSLayoutConstraint.Axis) -> UIStackView{
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.spacing = spacing
        
        if views.count != ratios.count{
            print("(Error) Not Ratios and Views Count are mismatching !")
        }
        
        for count in 0..<views.count{
            let view = views[count]
            let ratio = ratios[count]
            
            stack.addArrangedSubview(view)
            
            if axis == .vertical{
                view.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: ratio,constant: -(count == 0 || count == views.count - 1 ? spacing * 0.5 : spacing)).isActive = true
            }else if axis == .horizontal{
                view.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: ratio,constant: -(count == 0 || count == views.count - 1 ? spacing * 0.5 : spacing)).isActive = true
            }
        }
        
        return stack
    }
    
}

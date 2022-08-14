//
//  CustomImageView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 29/05/2022.
//

import Foundation
import UIKit
import SDWebImage


class CustomImageView:UIImageView{
        
    private let imageDownloader:ImageDownloader = ImageDownloader()
    private var colors:[UIColor] = []
    private var named:String? = nil
    private var url:String? = nil
	
	private lazy var gradientView: UIView = { .init() }()
	
	init(url:String? = nil,
         named:String? = nil,
         cornerRadius:CGFloat,
         maskedCorners:CACornerMask? = nil){
        super.init(frame: .zero)
        self.named = named
        self.url = url
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        if let safeMaskedCorner = maskedCorners{
            self.layer.maskedCorners = safeMaskedCorner
        }
        self.setupImageView()
    }
    
    
    convenience init(
        cornerRadius:CGFloat,
        maskedCorners:CACornerMask? = nil,
        gradientColors:[UIColor]
    ){
		self.init(url: nil, named: nil, cornerRadius: cornerRadius, maskedCorners: maskedCorners)
        self.colors = gradientColors
        self.setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let safeGradient = self.gradient{
            safeGradient.frame = self.frame
        }
    }
    
    private var gradient:CAGradientLayer? = nil
    
    private func setupImageView(){
        if let safeNamed = self.named{
            self.image = .init(named: safeNamed)
		} else if let validUrl = url {
			UIImage.loadImage(url: validUrl, for: self, at: \.image)
		} else {
			backgroundColor = .appGrayColor.withAlphaComponent(0.15)
		}
		
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        if !self.colors.isEmpty{
            self.gradientView = UIView()
            self.gradient = CAGradientLayer()
            self.gradient!.colors = self.colors.compactMap({$0.cgColor})
            self.buildGradientView()
        }
    }
        
    func buildGradientView(){
	
		guard let validGradient = gradient else { return }
		
		gradientView.layer.addSublayer(validGradient)
        
        addSubview(gradientView)
        
		setContraintsToChild(gradientView, edgeInsets: .zero)
    }

}

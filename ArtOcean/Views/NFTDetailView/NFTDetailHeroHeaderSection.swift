//
//  NFTDetailHeroHeaderSection.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 01/06/2022.
//

import Foundation
import UIKit

class NFTHeroHeaderView:UIView{
    
    //MARK: - View Properties
    private var onCloseHandler:(() -> Void)
    private var height:CGFloat
    private var imageScale:CGFloat = 1
	public let originalImageHeight:CGFloat = UIScreen.main.bounds.height * 0.35
    
    //MARK: - Views
    private lazy var backgroundImageView:CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 0)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var heroHeaderView:StreachyHeaderView = StreachyHeaderView(height: self.height, innerView: backgroundImageView)
    
    private lazy var imageView:CustomImageView = .init(cornerRadius: 16)
    
    private let leftButton:CustomButton

    
    //MARK: - View LifeCycle and Init
    
    init(nft:NFTModel,height:CGFloat,handler:@escaping (() -> Void)){
        self.leftButton = CustomButton(systemName: "chevron.left", handler: handler, autolayout: true)
        self.height = height
        self.onCloseHandler = handler
		super.init(frame:.init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: height + originalImageHeight * 0.5)))
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setupViews()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        self.addSubview(heroHeaderView)
        self.addSubview(leftButton)
        self.addSubview(imageView)
    }
    
    public func updateImages(url:String){
        backgroundImageView.updateImageView(url: url)
        imageView.updateImageView(url: url)
    }
    
    func animateHeaderView(_ scrollView:UIScrollView) ->  CGFloat{
        headerViewScrolled(scrollView)
        return animateImageView(scrollView)
    }
    
    public func headerViewScrolled(_ scrollView:UIScrollView){
        self.heroHeaderView.StretchOnScroll(scrollView)
    }
    
    public func animateImageView(_ scrollView:UIScrollView) -> CGFloat{
        let point = imageView.convert(scrollView.frame.origin, to: nil).y * imageScale
        let maxPoint = self.imageView.frame.minY
        let minPoint = -self.imageView.frame.height * 0.25
        let scaleFactor =  (point - minPoint)/(maxPoint - minPoint)
        self.imageScale = scaleFactor > 1 ? 1 : scaleFactor < 0.75 ? 0.75 : scaleFactor
        
        UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) {
			self.imageView.transform = .init(scaleX: self.imageScale, y: self.imageScale)
            self.imageView.layoutIfNeeded()
            scrollView.layoutIfNeeded()
        }.startAnimation()
		
		return originalImageHeight * 0.5 * imageScale + height
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            self.heroHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.heroHeaderView.topAnchor.constraint(equalTo: self.topAnchor),
            self.heroHeaderView.widthAnchor.constraint(equalTo:self.widthAnchor),
            self.heroHeaderView.heightAnchor.constraint(equalToConstant: self.height),
            leftButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 3),
            leftButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 5),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			imageView.topAnchor.constraint(equalTo: heroHeaderView.centerYAnchor),
			imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -50),
			imageView.heightAnchor.constraint(equalToConstant: originalImageHeight)
        ])
    }
	    
//    override var intrinsicContentSize: CGSize{
//		return .init(width: UIScreen.main.bounds.width, height: height + originalImageHeight * 0.5)
//    }
    
}

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
	private var nftArt:NFTModel
    
    //MARK: - Views
    private lazy var backgroundImageView:CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 0)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var heroHeaderView:StreachyHeaderView = StreachyHeaderView(height: height - 132, innerView: backgroundImageView)
    
    private lazy var imageView:CustomImageView = .init(cornerRadius: 16)
    
    private let leftButton:CustomButton

    
    //MARK: - View LifeCycle and Init
    
    init(nft:NFTModel,height:CGFloat,handler:@escaping (() -> Void)){
        self.leftButton = CustomButton(systemName: "chevron.left", handler: handler, autolayout: true)
        self.height = height
        self.onCloseHandler = handler
		nftArt = nft
		super.init(frame:.init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: height)))
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
		guard let img = nftArt.metadata?.image else { return }
		updateImages(url: img)
    }
    
    public func updateImages(url:String){
        backgroundImageView.updateImageView(url: url)
        imageView.updateImageView(url: url)
    }
    
    func animateHeaderView(_ scrollView:UIScrollView) ->  CGFloat{
		heroHeaderView.StretchOnScroll(scrollView)
        return animateImageView(scrollView)
    }
    
    public func headerViewScrolled(_ scrollView:UIScrollView){
		heroHeaderView.StretchOnScroll(scrollView)
    }
	
    public func animateImageView(_ scrollView:UIScrollView) -> CGFloat{
		let point = scrollView.contentOffset.y
		let totalHeight = height
        let maxPoint = totalHeight
		let minPoint = totalHeight * 0.5
		let scaleFactor =  -(point - minPoint)/(maxPoint - minPoint)
		self.imageScale = scaleFactor > 1 ? 1 : scaleFactor < 0 ? 0 : scaleFactor
		
		UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) { [weak self] in
			let scale = self?.imageScale ?? 0
			self?.imageView.transform = .init(scaleX: scale, y: scale)
			self?.heroHeaderView.alpha = scale
			self?.imageView.layoutIfNeeded()
			scrollView.layoutIfNeeded()
		}.startAnimation()

		
		return originalImageHeight * 0.5 * imageScale + height
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
			heroHeaderView.topAnchor.constraint(equalTo: topAnchor),
			heroHeaderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
			heroHeaderView.heightAnchor.constraint(equalToConstant: height - 132),
            leftButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 3),
            leftButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 5),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			imageView.topAnchor.constraint(equalTo: heroHeaderView.topAnchor,constant: 132),
//			imageView.centerYAnchor.constraint(equalTo: heroHeaderView.bottomAnchor),
			imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 50),
			imageView.heightAnchor.constraint(equalToConstant: originalImageHeight)
        ])
    }
	    
//    override var intrinsicContentSize: CGSize{
//		return .init(width: UIScreen.main.bounds.width, height: height + originalImageHeight * 0.5)
//    }
    
}

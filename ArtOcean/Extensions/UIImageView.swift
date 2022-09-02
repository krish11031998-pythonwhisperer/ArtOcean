//
//  UIImageView.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 24/05/2022.
//

import UIKit
import ImageIO
import SDWebImage

extension UIImageView {
	public func updateImageView(url:String?){
		guard let safeURL = url else {return}
		ImageDownloader.shared.fetchImage(urlStr: safeURL) {result in
			switch result{
			case .success(let image):
				DispatchQueue.main.async { [weak self] in
					self?.image = image
				}
			case .failure(let err):
				print("(Error) err : ",err.localizedDescription)
				
			}
		}
	}
	
	func blurGradientBackDrop(size: CGSize) {
		let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .light ? .light : .dark)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = .init(origin: .zero, size: size)
		blurEffectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//		insertSubview(blurEffectView, at: 0)
		addSubview(blurEffectView)
		
		let gradientView: UIView = .init()
		gradientView.addGradientLayer(size: size)
		gradientView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
		addSubview(gradientView)
		//addGradientLayer(size: size)
	}

	static func buildCatalogueImageView(name: UIImage.Catalogue, size: CGSize) -> UIImageView {
		let imageView = UIImageView(frame: .init(origin: .zero, size: size))
		imageView.image = name.image
		imageView.contentMode = .scaleAspectFit
		return imageView
	}
}

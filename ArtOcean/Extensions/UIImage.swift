//
//  UIImage.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 04/08/2022.
//

import Foundation
import UIKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
	return l < r
  case (nil, _?):
	return true
  default:
	return false
  }
}


extension UIImage {
	
//    public class func gifImageWithData(_ data: Data) -> UIImage? {
//        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
//            print("image doesn't exist")
//            return nil
//        }
//
//        return UIImage.animatedImageWithSource(source)
//    }
//
//    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
//        guard let bundleURL:URL? = URL(string: gifUrl)
//            else {
//                print("image named \"\(gifUrl)\" doesn't exist")
//                return nil
//        }
//        guard let imageData = try? Data(contentsOf: bundleURL!) else {
//            print("image named \"\(gifUrl)\" into NSData")
//            return nil
//        }
//
//        return gifImageWithData(imageData)
//    }
//
//    public class func gifImageWithName(_ name: String) -> UIImage? {
//        guard let bundleURL = Bundle.main
//            .url(forResource: name, withExtension: "gif") else {
//                print("SwiftGif: This image named \"\(name)\" does not exist")
//                return nil
//        }
//        guard let imageData = try? Data(contentsOf: bundleURL) else {
//            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
//            return nil
//        }
//
//        return gifImageWithData(imageData)
//    }
	
	class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
		var delay = 0.1
		
		let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
		let gifProperties: CFDictionary = unsafeBitCast(
			CFDictionaryGetValue(cfProperties,
				Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
			to: CFDictionary.self)
		
		var delayObject: AnyObject = unsafeBitCast(
			CFDictionaryGetValue(gifProperties,
				Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
			to: AnyObject.self)
		if delayObject.doubleValue == 0 {
			delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
				Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
		}
		
		delay = delayObject as! Double
		
		if delay < 0.1 {
			delay = 0.1
		}
		
		return delay
	}
	
	class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
		var a = a
		var b = b
		if b == nil || a == nil {
			if b != nil {
				return b!
			} else if a != nil {
				return a!
			} else {
				return 0
			}
		}
		
		if a < b {
			let c = a
			a = b
			b = c
		}
		
		var rest: Int
		while true {
			rest = a! % b!
			
			if rest == 0 {
				return b!
			} else {
				a = b
				b = rest
			}
		}
	}
	
	class func gcdForArray(_ array: Array<Int>) -> Int {
		if array.isEmpty {
			return 1
		}
		
		var gcd = array[0]
		
		for val in array {
			gcd = UIImage.gcdForPair(val, gcd)
		}
		
		return gcd
	}
	
	class func animatedImageWithSource(_ source: CGImageSource,downsampleOptions:CFDictionary? = nil) -> UIImage? {
		let count = CGImageSourceGetCount(source)
		var images = [CGImage]()
		var delays = [Int]()
		
		for i in 0..<count {
			if let image = CGImageSourceCreateImageAtIndex(source, i, downsampleOptions) {
				images.append(image)
			}
			
			let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
				source: source)
			delays.append(Int(delaySeconds * 500.0)) // Seconds to ms
		}
		
		let duration: Int = {
			var sum = 0
			
			for val: Int in delays {
				sum += val
			}
			
			return sum
		}()
		
		let gcd = gcdForArray(delays)
		var frames = [UIImage]()
		
		var frame: UIImage
		var frameCount: Int
		for i in 0..<count {
			frame = UIImage(cgImage: images[Int(i)])
			frameCount = Int(delays[Int(i)] / gcd)
			
			for _ in 0..<frameCount {
				frames.append(frame)
			}
		}
		
		let animation = UIImage.animatedImage(with: frames,
			duration: Double(duration) / 1000.0)
		
		return animation
	}
	
	static func downsample(imageData: Data,to pointSize: CGSize,scale: CGFloat = UIScreen.main.scale) -> UIImage? {
		
		// Create an CGImageSource that represent an image
		let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
		guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else {
			return nil
		}
		
		// Calculate the desired dimension
		let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
		
		// Perform downsampling
		let downsampleOptions = [
			kCGImageSourceCreateThumbnailFromImageAlways: true,
			kCGImageSourceShouldCacheImmediately: true,
			kCGImageSourceCreateThumbnailWithTransform: true,
			kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
		] as CFDictionary
		guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
			return nil
		}
		
		// Return the downsampled image as UIImage
		let count = CGImageSourceGetCount(imageSource)
		return UIImage(cgImage: downsampledImage)
		
	}
	
	func resized(_ newSize:CGSize) -> UIImage {
		let renderer = UIGraphicsImageRenderer(size: newSize)
		let image = renderer.image(actions: { _ in self.draw(in: .init(origin: .zero, size: newSize))})
		let newImage = image.withRenderingMode(renderingMode)
		return newImage
	}
	
//	func resized(to size: CGSize) -> UIImage {
//		
//		let renderer = UIGraphicsImageRenderer(size: size)
//		let img = renderer.image { _ in self.draw(in: .init(origin: .zero, size: size)) }
//		
//		return img
//	}
	
	static func loadCache(_ urlString:String) -> UIImage? {
		guard
			let url = URL(string: urlString),
			let img = ImageCache.cache[url]
		else { return nil }
		return img
	}
	
	static func solid(color: UIColor, frame: CGSize = .smallestSqaure) -> UIImage {
		let view = UIView(frame: .init(origin: .zero, size: frame))
		view.backgroundColor = color
		return view.snapshot
	}
	
	func roundedImage(cornerRadius: CGFloat = 8) -> UIImage? {
		let imageView: UIImageView = .init(image: self)
		imageView.contentMode = .scaleAspectFill
		imageView.bordered(cornerRadius: cornerRadius, borderWidth: 0, borderColor: .clear)
		imageView.clipsToBounds = true
		return imageView.snapshot
	}
	
	static func customButtonImage(
		name: UIImage.Catalogue,
		size: CGSize = .squared(64),
		tintColor: UIColor = .appGrayColor,
		bgColor: UIColor = .appGrayColor.withAlphaComponent(0.15),
		bordered: Bool = false
	) -> UIImage? {
		CustomImageButton(name: name, frame: size, addBG: true, tintColor: tintColor, bgColor: bgColor, bordered: bordered, handler: nil).snapshot
	}
	
}

//MARK: - UIImage Catalogue

extension UIImage {
	
	enum Catalogue: String {
		
		case arrowUpLeft = "arrow-up-left"
		case arrowUpRight = "arrow-up-right"
		case arrowUp = "arrow-up"
		case arrowDown = "arrow-down"
		case chartBar = "chart-bar"
		case chartSquareBarOutline = "chart-square-bar-outline"
		case chartSquareBar = "chart-square-bar"
		case check = "check"
		case chevronDown = "cheveron-down"
		case chevronLeft = "cheveron-left"
		case chevronRight = "cheveron-right"
		case clock = "clock"
		case cloudDownload = "cloud-download"
		case cog = "cog"
		case creditCard = "credit-card"
		case creditCardOutline = "credit-card-outline"
		case dotsVertical = "dots-vertical"
		case duplicate = "duplicate"
		case eyeOff = "eye-off"
		case eye = "eye"
		case eth = "eth"
		case heartOutline = "heart-outline"
		case heart = "heart"
		case homeOutline = "home-outline"
		case home = "home"
		case link = "link"
		case lockClosed = "lock-closed"
		case mail = "mail"
		case menu = "menu-alt-3"
		case minus = "minus"
		case moon = "moon"
		case pencil = "pencil-alt"
		case photograph = "photograph"
		case play = "play"
		case plus = "plus"
		case qrCode = "qrcode"
		case searchOutline = "search-outline"
		case search = "search"
		case share = "share"
		case shieldCheck = "shield-check"
		case switchHorizontal = "switch-horizontal"
		case trash = "trash"
		case trendingUp = "trending-up"
		case userOutline = "user-outline"
		case user = "user"
		case viewGridAdd = "view-grid-add"
		case viewGrid = "view-grid"
		case xMark = "x"
		
		var image: UIImage { .init(named: self.rawValue) ?? .solid(color: .appBlackColor.withAlphaComponent(0.125), frame: .smallestSqaure) }
	}
	
	static func buildCatalogueImage(name: Catalogue, size: CGSize) -> UIImage {
		let imageView = UIImageView(frame: .init(origin: .zero, size: size))
		imageView.image = name.image
		return imageView.snapshot
	}
	
	static func buildCatalogueImage(name: Catalogue, borderRadius: CGFloat, size: CGSize) -> UIImage {
		let imageView = UIImageView(frame: .init(origin: .zero, size: size))
		imageView.image = name.image.resized(size * 0.6)
		imageView.contentMode = .center
		imageView.bordered(cornerRadius: borderRadius)
		return imageView.snapshot
	}
	
	static func loadImage<T:AnyObject>(url: String?, for object: T, at path: ReferenceWritableKeyPath<T,UIImage?>) {
		guard let validUrlStr = url else { return }
		ImageDownloader.shared.fetchImage(urlStr: validUrlStr) { result  in
			switch result {
				case .success(let image):
					DispatchQueue.main.async {
						object[keyPath: path] = image
					}
				case .failure(let err):
					print("(DEBUG) err : ",err.localizedDescription)
			}
		}
	}
	
	static var loadingBackgroundImage: UIImage {
		.solid(color: .appGrayColor.withAlphaComponent(0.15),frame: .squared(40))
	}
	
	func imageView(size: CGSize = .smallestSqaure, cornerRadius: CGFloat = .zero) -> UIImageView {
		let view = UIImageView(frame: size.frame)
		view.image = self
		view.contentMode = .scaleAspectFit
		view.clipsToBounds = true
		view.cornerRadius = cornerRadius
		return view
	}
}

//MARK: - UIImageStylist

enum ImageStyle {
	case rounded(CGFloat)
	case circle(CGSize)
	case original
	
	var cornerRadius : CGFloat {
		switch self {
		case .rounded(let radius):
			return radius
		case .circle(let size):
			return size.width * 0.5
		case .original:
			return 0
		}
	}
	
}


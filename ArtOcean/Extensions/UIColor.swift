//
//  UIColor.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import UIKit
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    static var appBlueColor:UIColor = .init(hexString: "2281E3")
    static var appGrayColor:UIColor = .init(hexString: "8D98AF")
    static var appGreenColor:UIColor = .init(hexString: "0AB27D")
    static var appBlackColor:UIColor = .init(hexString: "081131")
    static var appWhiteBackgroundColor:UIColor = .init(hexString: "F8FAFC")
    static var appOrangeColor:UIColor = .init(hexString: "D59A31")
    static var appRedColor:UIColor = .init(hexString: "E57434")
    static var appVioletColor:UIColor = .init(hexString: "D67F7F")
    static var appDarkGrayColor:UIColor = .init(hexString: "3C3C3C")
    static var appPurpleColor:UIColor = .init(hexString: "5D5FEF")
    static var appPurple50Color:UIColor = .init(hexString: "EFEFFD")
	
	enum Catalogue: String {
		case greyscale50
		case greyscale100
		case greyscale200
		case greyscale300
		case greyscale400
		case greyscale500
		case greyscale600
		case greyscale700
		case greyscale800
		case greyscale900
		case purple50
		case purple100
		case purple200
		case purple300
		case purple400
		case purple500
		case purple600
		case purple700
		case purple800
		case purple900
		case appBlue
		case appGreen
		case appRed
		case appOrange
		case surfaceBackground
		case surfaceBackgroundInverse
		case subtitleColor
		case textColor
		
		var color: UIColor {
			.init(named: self.rawValue) ?? .black
		}
	}
	
	static var greyscale50 : UIColor { Catalogue.greyscale50.color }
	static var greyscale100 : UIColor { Catalogue.greyscale100.color }
	static var greyscale200 : UIColor { Catalogue.greyscale200.color }
	static var greyscale300 : UIColor { Catalogue.greyscale300.color }
	static var greyscale400 : UIColor { Catalogue.greyscale400.color }
	static var greyscale500 : UIColor { Catalogue.greyscale500.color }
	static var greyscale600 : UIColor { Catalogue.greyscale600.color }
	static var greyscale700 : UIColor { Catalogue.greyscale700.color }
	static var greyscale800 : UIColor { Catalogue.greyscale800.color }
	static var greyscale900 : UIColor { Catalogue.greyscale900.color }
	static var purple50 : UIColor { Catalogue.purple50.color }
	static var purple100 : UIColor { Catalogue.purple100.color }
	static var purple200 : UIColor { Catalogue.purple200.color }
	static var purple300 : UIColor { Catalogue.purple300.color }
	static var purple400 : UIColor { Catalogue.purple400.color }
	static var purple500 : UIColor { Catalogue.purple500.color }
	static var purple600 : UIColor { Catalogue.purple600.color }
	static var purple700 : UIColor { Catalogue.purple700.color }
	static var purple800 : UIColor { Catalogue.purple800.color }
	static var purple900 : UIColor { Catalogue.purple900.color }
	static var appBlue : UIColor { Catalogue.appBlue.color }
	static var appGreen : UIColor { Catalogue.appGreen.color }
	static var appRed : UIColor { Catalogue.appRed.color }
	static var appOrange : UIColor { Catalogue.appOrange.color }
	static var surfaceBackground : UIColor { Catalogue.surfaceBackground.color }
	static var surfaceBackgroundInverse : UIColor { Catalogue.surfaceBackgroundInverse.color }
	static var subtitleColor : UIColor { Catalogue.subtitleColor.color }
	static var textColor : UIColor { Catalogue.textColor.color }
}

//
//  CGPoint.swift
//  ArtOcean
//
//  Created by Krishna Venkatramani on 22/06/2022.
//

import Foundation
import UIKit

extension CGPoint{
    
    static func - (lhs:CGPoint,rhs:CGPoint) -> CGPoint{
        return .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
}

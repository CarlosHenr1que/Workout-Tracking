//
//  UIColor.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 02/07/24.
//

import Foundation
import UIKit

extension UIColor {
    
    static let backgroundColor = UIColor(hex: 0x171717)
    static let primaryColor = UIColor(hex: 0x202020)
    static let secondaryColor = UIColor(hex: 0x1AFF75)

    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

}

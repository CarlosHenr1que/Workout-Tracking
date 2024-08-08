//
//  TextField.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 09/07/24.
//

import Foundation
import UIKit

class TextField: UITextField {
    let padding: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: -16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
   
    init(frame: CGRect, placeholderText: String) {
        super.init(frame: frame)
        setup(placeholderText: placeholderText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(placeholderText: String) {
        translatesAutoresizingMaskIntoConstraints = false
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x6D6D6D), .font: UIFont(name: "Helvetica", size: 16) as Any]
        )
        textColor = .white
        borderStyle = .roundedRect
        backgroundColor = UIColor(hex: 0x202020)
    }
}

//
//  WTButton.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 19/08/24.
//

import UIKit

class WTButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setTitleColor(.primaryColor, for: .normal)
        titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
        backgroundColor = .secondaryColor
        layer.cornerRadius = 8
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}

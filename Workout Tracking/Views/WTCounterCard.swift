//
//  WTCounterCard.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 29/08/24.
//

import UIKit

class WTCounterCard: UIView {
    
    var onPressFirstButton: (() -> Void)?
    var onPressSecondButton: (() -> Void)?
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Series"
        return label
    }()
    
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(hex: 0xDCDCDC)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10"
        return label
    }()
    
    private lazy var firstButton: UIButton = {
       let view = UIButton()
        view.setTitle("-", for: .normal)
        return view
    }()
    
    private lazy var secondButton: UIButton = {
       let view = UIButton()
        view.setTitle("+", for: .normal)
        return view
    }()
    
    private lazy var couterStackView: UIStackView = {
       let view = UIStackView(arrangedSubviews: [firstButton, subTitle, secondButton])
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [title, couterStackView])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private func setupViews() {
        self.backgroundColor = UIColor(hex: 0x202020)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.secondaryColor.cgColor
    }
    
    public func configure(_ title: String, _ subTitle: String) {
        self.title.text = title
        self.subTitle.text = subTitle
    }
    
    private func setupButton() {
        firstButton.addTarget(self, action: #selector(firstButtonPress), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(secondButtonPress), for: .touchUpInside)
    }
    
    @objc private func firstButtonPress() {
        onPressFirstButton?()
    }
    
    @objc private func secondButtonPress() {
        onPressSecondButton?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setup()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setup()
    }
}


extension WTCounterCard: ViewCode {
    func buildHierarchy() {
        self.addSubview(containerStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }
}

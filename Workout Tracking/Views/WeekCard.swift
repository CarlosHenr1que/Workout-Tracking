//
//  WeekCard.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 02/07/24.
//

import UIKit

import UIKit

class WeekCard: UIView {
    
    let days = ["S", "T", "Q", "Q", "S", "S", "D"]
    
    var onPress: (() -> Void)?
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setup()
    }
    
    func getCurrentWeekDay() -> Int {
        let weekday = Calendar.current.component(.weekday, from: Date())
        if weekday == 1 {
            return 7
        }
        return weekday - 1
    }
    
    func getCurrentDayStatus(_ weekday: Int, _ currentDay: Int) -> Int {
        if weekday > currentDay {
            return 0
        }
        if weekday == currentDay {
            return 1
        }
        return 2
    }
    
    private func setupViews() {
        backgroundColor = UIColor(hex: 0x202020)
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    private func createRoundedView(_ text: String, _ status: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = status == 0 ? UIColor(hex: 0x1AFF75) : UIColor(hex: 0x000000)
        view.layer.cornerRadius = 21
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = status == 2 ? UIColor(hex: 0x000000).cgColor : UIColor(hex: 0x1AFF75).cgColor 
        
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 16)
        label.text = text
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 42),
            view.heightAnchor.constraint(equalToConstant: 42),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    @objc func handleTap() {
        onPress?()
      }
}

extension WeekCard: ViewCode {
    
    func buildWeekDays() {
        let weekday = getCurrentWeekDay()
        
        for (index, day) in days.enumerated() {
            let status = getCurrentDayStatus(weekday, index + 1)
            let view = createRoundedView(day, status)
            stackView.addArrangedSubview(view)
        }
    }
    
    
    func buildHierarchy() {
        self.addSubview(stackView)
        self.buildWeekDays()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    
    func applyAdditionalChanges() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
}



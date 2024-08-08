//
//  ViewCode.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 02/07/24.
//


import Foundation

protocol ViewCode {
    func buildHierarchy()
    func setupConstraints()
    func applyAdditionalChanges()
}

extension ViewCode {
    func setup() {
        buildHierarchy()
        setupConstraints()
        applyAdditionalChanges()
    }
    
    func buildHierarchy() {}
    
    func setupConstraints() {}
    
    func applyAdditionalChanges() {}
}


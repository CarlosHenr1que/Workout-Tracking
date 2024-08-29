//
//  ExerciseFormViewController.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 07/07/24.
//

import UIKit

class ExerciseFormViewController: UIViewController {
    var exerciseCreatedCallback:((Exercise) -> Void)?
    
    private lazy var nameTextField: UITextField = {
        TextField(frame: .zero, placeholderText: "Nome do exercício")
    }()
    
    private lazy var setsTextField: UITextField = {
        let view = TextField(frame: .zero, placeholderText: "Series")
        view.keyboardType = .numberPad
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigator()
        setup()
        self.view.backgroundColor = UIColor.backgroundColor
        setupKeyboardDismissListener()
    }
    
    func setupKeyboardDismissListener() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    func setupNavigator() {
        title = "Adicionar exercício"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        let leftButtonItem = UIBarButtonItem(title: "Voltar", style: .plain, target: self, action: #selector(goBackButtonTapped))
        let rightButtonItem = UIBarButtonItem(title: "Salvar", style: .plain, target: self, action: #selector(saveButtonTapped))
        leftButtonItem.tintColor = UIColor(hex: 0x1AFF75)
        rightButtonItem.tintColor = UIColor(hex: 0x1AFF75)
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func goBackButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func saveButtonTapped() {
        if let name = nameTextField.text, let sets = setsTextField.text {
            let exercise = Exercise()
            exercise.name = name
            exercise.sets = Int(sets) ?? 0
            exerciseCreatedCallback?(exercise)
        }
        self.dismiss(animated: true)
    }
}

extension ExerciseFormViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(nameTextField)
        view.addSubview(setsTextField)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            setsTextField.heightAnchor.constraint(equalToConstant: 50),
            setsTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            setsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            setsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

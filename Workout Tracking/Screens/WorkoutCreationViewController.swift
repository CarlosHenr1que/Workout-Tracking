//
//  WorkoutCreationViewController.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 04/07/24.
//

import UIKit
import RealmSwift

class WorkoutCreationViewController: UIViewController {
    var exercises = List<Exercise>()
    var workoutCreatedCallback:((Workout) -> Void)?
    var workout: Workout?
    private var weekday: Int?
    
    private lazy var nameTextField: TextField = {
        let field = TextField(frame: .zero, placeholderText: "Nome do treino")
        return field
    }()
    
    private lazy var weekdayTextField: TextField = {
        let field = TextField(frame: .zero, placeholderText: "Dia da semana")
        return field
    }()
        
    private lazy var exerciseLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.text = "Exercícios"
        view.font = UIFont(name: "Helvetica-Bold", size: 15)
        return view
    }()
    
    private lazy var addExerciseButton: UIButton = {
        let view = UIButton()
        view.setTitle("Adicionar", for: .normal)
        return view
    }()
    
    private lazy var exercisesLabelStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.addArrangedSubview(exerciseLabel)
        view.addArrangedSubview(addExerciseButton)
        return view
    }()
    
    private lazy var exercisesTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.registerCell(type: SimpleTableViewCell.self)
        view.separatorStyle = .none
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let view = UIButton()
        view.setTitle("Salvar", for: .normal)
        view.setTitleColor(.primaryColor, for: .normal)
        view.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
        view.backgroundColor = .secondaryColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        setupScreen()
        setup()
        setupKeyboardDismissListener()
        weekdayTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressWeekDayInput)))
    }
    
    @objc func onPressWeekDayInput() {
        let optionsViewController = UIAlertController(title: "Selecione o dia da semana", message: nil, preferredStyle: .actionSheet)
        for week in WeekDayHelper.week {
            let action = UIAlertAction(title: week, style: .default) { _ in
                self.weekdayTextField.text = week
            }
            optionsViewController.addAction(action)
        }
        present(optionsViewController, animated: true)
    }
    
    func setupKeyboardDismissListener() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    func isFormFullFilled() -> Bool {
        return nameTextField.text != "" && weekdayTextField.text != "" && exercises.count > 0
    }
    
    func createPendingInformationAlert() -> UIAlertController {
        let missingInformationAlert = UIAlertController(title: "Informações pendentes", message: "Preencha todas as informaçøes", preferredStyle: .alert)
        missingInformationAlert.addAction(UIAlertAction(title: "Voltar", style: .default))
        return missingInformationAlert
    }
    
    @objc func saveButtonPressed() {
        if !isFormFullFilled() {
            let missingInformationAlert = UIAlertController(title: "Informações pendentes", message: "Preencha todas as informaçøes", preferredStyle: .alert)
            missingInformationAlert.addAction(UIAlertAction(title: "Voltar", style: .default))
            present(createPendingInformationAlert(), animated: true)
            return;
        }
        let name = nameTextField.text!
        
        if workout != nil {
            RealmManager.shared.update {
                workout?.name = name
                workout?.weekday = WeekDayHelper.week.firstIndex(of: weekdayTextField.text!)! + 1
                workout?.exercises = exercises
            }
            
            navigationController?.popViewController(animated: true)
            return
        }
        let newWorkout = Workout()
        newWorkout.name = name
        newWorkout.weekday = WeekDayHelper.week.firstIndex(of: weekdayTextField.text!)! + 1
        newWorkout.exercises = exercises
        workoutCreatedCallback?(newWorkout)
        navigationController?.popViewController(animated: true)
    }
    
    func setupNavigator() {
        title = "Adicionar treino"
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    func setCurrentWorkout() {
        if workout != nil {
            title = "Editar treino"
            nameTextField.text = workout?.name
            weekdayTextField.text = WeekDayHelper.getWeekdayText(weekday: workout!.weekday)
            print(workout!.weekday)
            exercises = workout!.exercises
            exercisesTableView.reloadData()
        }
    }

    func setupScreen() {
        setupNavigator()
        view.backgroundColor = UIColor.backgroundColor
        addExerciseButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        setCurrentWorkout()
    }
    
    @objc func addButtonTapped() {
        let vc = ExerciseFormViewController()
        vc.exerciseCreatedCallback = {exercise in
            RealmManager.shared.update {
                self.exercises.append(exercise)
            }
            self.exercisesTableView.reloadData()
        }
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension WorkoutCreationViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(nameTextField)
        view.addSubview(weekdayTextField)
        view.addSubview(exercisesLabelStack)
        view.addSubview(exercisesTableView)
        view.addSubview(saveButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            weekdayTextField.heightAnchor.constraint(equalToConstant: 50),
            weekdayTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            weekdayTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekdayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            exercisesLabelStack.topAnchor.constraint(equalTo: weekdayTextField.bottomAnchor, constant: 20),
            exercisesLabelStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            exercisesLabelStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            exercisesTableView.topAnchor.constraint(equalTo: exercisesLabelStack.bottomAnchor, constant: 10),
            exercisesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            exercisesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exercisesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension WorkoutCreationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: SimpleTableViewCell.self, for: indexPath) as? SimpleTableViewCell else {
            return UITableViewCell()
        }
        let exercise = exercises[indexPath.row]
        cell.configure(title: exercise.name, subTitle: "Series: \(String(exercise.sets))")
        return cell
    }
}

//
//  HomeViewController.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 02/07/24.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    var currentWorkout: Workout?
    var currentHistory: History?
    
    private lazy var weekCardView: WeekCard = {
        let view = WeekCard()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var workoutCard: WorkoutCard = {
        let view = WorkoutCard()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var workoutButton: WTButton = {
        let view = WTButton()
        view.setTitle("Começar", for: .normal)
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.alpha = 1.0
        return view
    }()
    
    private lazy var createWorkoutButton: WTButton = {
        let view = WTButton()
        view.setTitle("Criar novo treino", for: .normal)
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.alpha = 1.0
        return view
    }()
    
    private lazy var currentWorkoutLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.text = "Treino atual"
        view.font = UIFont(name: "Helvetica-Bold", size: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    private func configureScreen() {
        setupScreen()
        setupNavigator()
        setup()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCurrentWorkout()
    }
    
    func configureConcludedWorkout(_ history: History) {
        currentHistory = history
        workoutCard.isHidden = false
        workoutButton.isHidden = true
        currentWorkoutLabel.isHidden = false
        createWorkoutButton.isHidden = true
        currentWorkoutLabel.text = "Treino concluído"
        let count = String(history.workout!.exercises.count)
        workoutCard.configure(history.workout!.name, "\(count) Exercicios")
    }
    
    func configureInProgress(_ history: History) {
        currentWorkoutLabel.isHidden = false
        workoutButton.setTitle("Continuar", for: .normal)
        currentWorkoutLabel.text = "Treino atual"
        workoutCard.isHidden = false
        workoutButton.isHidden = false
        createWorkoutButton.isHidden = true
        currentHistory = history
        workoutCard.configure(history.workout!.name, "\(String(history.workout!.exercises.count)) Exercicios")
    }
    
    func configureCurrentWorkout(_ workout: Workout) {
        workoutButton.setTitle("Começar", for: .normal)
        currentWorkoutLabel.text = "Treino atual"
        currentWorkout = workout
        createWorkoutButton.isHidden = true
        workoutCard.isHidden = false
        workoutButton.isHidden = false
        currentWorkoutLabel.isHidden = false
        workoutCard.configure(workout.name, "\(String(workout.exercises.count)) Exercicios")
    }
    
    func setupCurrentWorkout() {
        guard let todayHistory = getTodayHistory() else {
            currentHistory = nil
            
            guard let todayWorkout = getTodayWorkout() else {
                createWorkoutButton.isHidden = false
                return
            }
            configureCurrentWorkout(todayWorkout)
            return
        }
        if todayHistory.concluded == true {
            configureConcludedWorkout(todayHistory)
            return
        }
        configureInProgress(todayHistory)
    }
    
    func getTodayWorkout() -> Workout? {
        let workouts = RealmManager.shared.fetch(Workout.self, filter: "weekday = %@", args: WeekDayHelper.getCurrentWeekday())
        return workouts.first
    }
    
    func getTodayHistory() -> History? {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let histories = RealmManager.shared.fetch(History.self, filter: "date >= %@ AND date < %@", args: today, tomorrow)
        return histories.first
    }
    
    func setupActions() {
        weekCardView.onPress = {
            self.navigateToWorkoutList()
        }
        workoutButton.addTarget(self, action: #selector(onPressWorkouButton), for: .touchUpInside)
        workoutCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressWorkoutCard)))
        createWorkoutButton.addTarget(self, action: #selector(navigateToWorkoutList), for: .touchUpInside)
    }
    
    @objc func navigateToWorkoutList() {
        self.navigationController?.pushViewController(WorkoutListViewController(), animated: true)
    }
    
    @objc func onPressWorkoutCard() {
        if currentHistory != nil && currentHistory?.concluded == true {
            let workoutHistoryViewController = WorkoutHistoryViewController()
            workoutHistoryViewController.history = currentHistory
            navigationController?.pushViewController(workoutHistoryViewController, animated: true)
            return
        }
    }
    
    @objc func onPressWorkouButton() {
        if currentHistory == nil {
            let history = History()
            history.date = Date()
            history.workout = currentWorkout
            RealmManager.shared.add(history)
            currentHistory = history
        }
        let vc = WorkoutProgressViewController()
        vc.workoutHistory = currentHistory
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupScreen() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
    func setupNavigator() {
        title = WeekDayHelper.getWeekdayText()
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(onHistoryButtonPress))
        rightBarButtonItem.tintColor = UIColor.secondaryColor
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func onHistoryButtonPress() {
        let vc = HistoryListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(weekCardView)
        view.addSubview(workoutCard)
        view.addSubview(currentWorkoutLabel)
        view.addSubview(workoutButton)
        view.addSubview(createWorkoutButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            weekCardView.heightAnchor.constraint(equalToConstant: 90),
            weekCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            currentWorkoutLabel.topAnchor.constraint(equalTo: weekCardView.bottomAnchor, constant: 20),
            currentWorkoutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            workoutCard.topAnchor.constraint(equalTo: currentWorkoutLabel.bottomAnchor, constant: 10),
            workoutCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            workoutButton.heightAnchor.constraint(equalToConstant: 45),
            workoutButton.topAnchor.constraint(equalTo: workoutCard.bottomAnchor, constant: 10),
            workoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            createWorkoutButton.heightAnchor.constraint(equalToConstant: 45),
            createWorkoutButton.topAnchor.constraint(equalTo: currentWorkoutLabel.bottomAnchor, constant: 10),
            createWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createWorkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

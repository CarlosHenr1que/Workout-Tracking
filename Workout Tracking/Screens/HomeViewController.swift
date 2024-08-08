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
    
    private lazy var workoutButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Começar", for: .normal)
        view.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
        view.backgroundColor = UIColor.primaryColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.alpha = 1.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setupNavigator()
        setup()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCurrentWorkout()
    }
    
    func setupCurrentWorkout() {
        if let todayHistory = getTodayHistory() {
            if todayHistory.concluded == true {
                workoutCard.isHidden = false
                workoutButton.isHidden = true
                currentHistory = todayHistory
                workoutCard.configure(todayHistory.workout!.name, "\(String(todayHistory.workout!.exercises.count)) Exercicios")
                return;
            }
            
            workoutButton.setTitle("Continuar", for: .normal)
            workoutCard.isHidden = false
            workoutButton.isHidden = false
            currentHistory = todayHistory
            workoutCard.configure(todayHistory.workout!.name, "\(String(todayHistory.workout!.exercises.count)) Exercicios")
        } else {
            currentHistory = nil
            if let todayWorkout = getTodayWorkout() {
                currentWorkout = todayWorkout
                workoutCard.isHidden = false
                workoutButton.isHidden = false
                workoutCard.configure(todayWorkout.name, "\(String(todayWorkout.exercises.count)) Exercicios")
            }
        }
    }
    
    func getTodayWorkout() -> Workout? {
        let workouts = RealmManager.shared.fetch(Workout.self, filter: "weekday = %@", args: getCurrentWeekday())
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
            self.navigationController?.pushViewController(WorkoutListViewController(), animated: true)
        }
        workoutButton.addTarget(self, action: #selector(onPressWorkouButton), for: .touchUpInside)
        workoutCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressWorkoutCard)))
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
    
    func getCurrentWeekday() -> Int {
        let calendar = Calendar.current
        let date = Date()
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday ?? 0
    }
    
    func setupScreen() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
    func setupNavigator() {
        title = "Treino da semana"
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
        view.addSubview(workoutButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            weekCardView.heightAnchor.constraint(equalToConstant: 90),
            weekCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            workoutCard.topAnchor.constraint(equalTo: weekCardView.bottomAnchor, constant: 10),
            workoutCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            workoutButton.heightAnchor.constraint(equalToConstant: 45),
            workoutButton.topAnchor.constraint(equalTo: workoutCard.bottomAnchor, constant: 10),
            workoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            workoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

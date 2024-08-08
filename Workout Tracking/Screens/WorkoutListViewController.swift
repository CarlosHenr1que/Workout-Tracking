//
//  WorkoutListViewController.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 04/07/24.
//

import UIKit
import RealmSwift

class WorkoutListViewController: UIViewController {
    var workoutList: Results<Workout>?
    var selectedWorkout: Workout?
    
    private lazy var workoutTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.registerCell(type: SimpleTableViewCell.self)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadWorkoutList()
        setupScreen()
        setup()
        setupTableViewRecognizer()
    }
    
    @objc func onCellLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: workoutTableView)
            if let indexPath = workoutTableView.indexPathForRow(at: touchPoint) {
                let workout = workoutList![indexPath.row]
                present(createMenuAlertController(workout), animated: true)
            }
        }
    }
    
    func setupTableViewRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onCellLongPress))
        workoutTableView.addGestureRecognizer(longPress)
    }
    
    func createMenuAlertController(_ workout: Workout) -> UIAlertController {
        let alertController = UIAlertController(title: "Gerenciar treinos", message: "O que deseja fazer ?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Voltar", style: .cancel, handler: {_ in }))
        alertController.addAction(UIAlertAction(title: "Excluir", style: .destructive, handler: {_ in
            RealmManager.shared.delete(workout)
            self.reloadWorkoutList()
        }))
        return alertController
        
    }
    
    func reloadWorkoutList() {
        workoutList =  RealmManager.shared.fetchAll(Workout.self).sorted(byKeyPath: "weekday", ascending: true)
        workoutTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadWorkoutList()
    }
    
    func createBarButton() {
        let plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = UIColor(hex: 0x1AFF75)
        plusButton.backgroundColor = UIColor(hex: 0x202020)
        plusButton.layer.cornerRadius = 15
        plusButton.clipsToBounds = true
        plusButton.addTarget(self, action: #selector(rightBarButtonTapped), for: .touchUpInside)
        plusButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func setupNavigator() {
        title = "Treinos"
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        createBarButton()
    }
    
    @objc func rightBarButtonTapped() {
        let vc = WorkoutCreationViewController()
        vc.workoutCreatedCallback = { workout in
            RealmManager.shared.add(workout)
            self.workoutList = RealmManager.shared.fetchAll(Workout.self)
            self.workoutTableView.reloadData()
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupScreen() {
        setupNavigator()
        view.backgroundColor = UIColor.backgroundColor
    }
}

extension WorkoutListViewController: ViewCode {
    func buildHierarchy() {
        self.view.addSubview(workoutTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            workoutTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            workoutTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            workoutTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            workoutTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
        ])
    }
}

extension WorkoutListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: SimpleTableViewCell.self, for: indexPath) as? SimpleTableViewCell else {
            return UITableViewCell()
        }
        if let workout = workoutList?[indexPath.row] {
            cell.configure(title: workout.name , subTitle: WeekDayHelper.getWeekdayText(weekday: workout.weekday) ?? "Segunda")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let workout = workoutList?[indexPath.row] {
            let vc = WorkoutCreationViewController()
            vc.workout = workout
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}


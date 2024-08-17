//
//  WorkoutHistoryViewController.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 26/07/24.
//

import UIKit

class WorkoutHistoryViewController: UIViewController {
    var history: History?
    
    private lazy var workoutTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.registerCell(type: SimpleTableViewCell.self)
        view.separatorStyle = .none
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        setup()
        configureScreen()
        configureNavigator()
    }
    
    private func configureScreen() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
    private func configureNavigator() {
        title = history?.workout?.name
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        configureDeleteButton()
    }
    
    private func configureDeleteButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onDeletePress))
    }
    
    @objc func onDeletePress() {
        RealmManager.shared.delete(history!)
        navigationController?.popViewController(animated: true)
    }

}

extension WorkoutHistoryViewController: ViewCode {
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

extension WorkoutHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return history?.exercises.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history?.exercises[section].sets.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: SimpleTableViewCell.self, for: indexPath) as? SimpleTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            let exercise = history?.exercises[indexPath.section].exercise?.name ?? "Unknown Exercise"
            cell.configure(title: exercise, subTitle: "")
        } else {
            let reps =  history?.exercises[indexPath.section].sets[indexPath.row - 1] ?? 0
            cell.configure(title: "\(indexPath.row)) Serie", subTitle: "Repetições \(reps)")
        }
        
        return cell
    }
}

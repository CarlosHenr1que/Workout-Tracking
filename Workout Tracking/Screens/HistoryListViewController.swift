//
//  HistoryListViewController.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 04/08/24.
//

import UIKit
import RealmSwift

class HistoryListViewController: UIViewController {
    var historyList: Results<History>?
    
    private lazy var historyTableView: UITableView = {
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
        setup()
        setupScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHistoryList()
    }
    
    func setupScreen() {
        setupNavigator()
        view.backgroundColor = UIColor.backgroundColor
    }
    
    func setupNavigator() {
        title = "Histórico"
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    func getHistoryList() {
        historyList = RealmManager.shared.fetchAll(History.self)
    }
}

extension HistoryListViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(historyTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            historyTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            historyTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            historyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
        ])
    }
}

extension HistoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: SimpleTableViewCell.self, for: indexPath) as? SimpleTableViewCell else {
            return UITableViewCell()
        }
        if let history = historyList?[indexPath.row] {
            let workout = history.workout!
            let title = workout.name
            let subTitle = WeekDayHelper.getWeekdayText(weekday: workout.weekday) ?? "Segunda"
            cell.configure(title: title, subTitle: subTitle)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let history = historyList?[indexPath.row] {
            let vc = WorkoutHistoryViewController()
            vc.history = history
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

//
//  WorkoutProgressViewController.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 19/07/24.
//

import UIKit

class SimpleCard: UIView {
    
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
        label.text = "1/4"
        return label
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [title, subTitle])
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
}

extension SimpleCard: ViewCode {
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

class WorkoutProgressViewController: UIViewController {
    var workoutHistory: History?
    var exerciseHistory: ExerciseHistory?
    var isResting: Bool?
    
    var timer: Timer?
    var totalTime: Float = 60.0
    var remainingTime: Float = 60.0
    
    private var exercise = "" {
        didSet {
            titleLabel.text = exercise
            descriptionLabel.text = "Exercício"
        }
    }
    
    private var sets = "1" {
        didSet {
            let total = exerciseHistory!.exercise!.sets
            setsCard.configure("Series", "\(sets)/\(total)")
        }
    }
    
    private var reps = 10 {
        didSet {
            repsCard.configure("Repetições", "\(reps)")
        }
    }
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Regular", size: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Exercício"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 40)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pulley frente"
        return label
    }()
    
    private lazy var progressBar: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progress = 1.0
        view.progressTintColor = .secondaryColor
        view.trackTintColor = .primaryColor
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var setsCard: SimpleCard = {
        let view = SimpleCard()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var repsCard: WTCounterCard = {
        let view = WTCounterCard()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var exerciseButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Próxima serie", for: .normal)
        view.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
        view.backgroundColor = UIColor.primaryColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var exerciseLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.text = "Exercícios"
        view.font = UIFont(name: "Helvetica-Bold", size: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureScreen()
    }
    
    func configureScreen() {
        view.backgroundColor = UIColor.backgroundColor
        setupNavigator()
        setupExercise()
        setupActions()
    }
    
    func updateSets() {
        sets = String(exerciseHistory!.sets.count)
    }
    
    func updateReps() {
        repsCard.configure("Repetições", "10")
    }
    
    func isLastSet() -> Bool {
        return exerciseHistory!.sets.count == exerciseHistory!.exercise!.sets
    }
    
    func updateButton() {
        if isLastSet()  {
            exerciseButton.setTitle("Próximo exercício", for: .normal)
        } else {
            if isResting == true {
                exerciseButton.setTitle("Continuar", for: .normal)
            } else {
                exerciseButton.setTitle("Próxima série", for: .normal)
            }
            
        }
    }
    
    func updateInformation() {
        exercise = exerciseHistory!.exercise!.name
        sets = String(exerciseHistory!.sets.count)
    }
    
    func getCurrentExerciseHistory(history: History) -> ExerciseHistory? {
        return history.exercises.first(where: { $0.id == history.currentExercise})
    }
    
    func createInitalExerciseHistory(history: History) {
        exerciseHistory = ExerciseHistory()
        exerciseHistory?.exercise = history.workout?.exercises.first
        RealmManager.shared.update {
            history.exercises.append(exerciseHistory!)
            history.currentExercise = exerciseHistory!.id
        }
    }
    
    func setupExercise() {
        guard let currentHistory = getCurrentExerciseHistory(history: workoutHistory!) else {
            createInitalExerciseHistory(history: workoutHistory!)
            updateInformation()
            return
        }
        exerciseHistory = currentHistory
        updateInformation()
    }
    
    func setupNavigator() {
        title = workoutHistory?.workout?.name
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    func setupActions() {
        exerciseButton.addTarget(self, action: #selector(onContinuePress), for: .touchUpInside)
        repsCard.onPressFirstButton = { self.reps = self.reps - 1}
        repsCard.onPressSecondButton = { self.reps = self.reps + 1}
    }
    
    func hasExerciseSetsFinished() -> Bool {
        return exerciseHistory!.sets.count < exerciseHistory!.exercise!.sets
    }
    
    func hasMoreSets() -> Bool {
        return exerciseHistory!.sets.count < exerciseHistory!.exercise!.sets
    }
    
    func saveCurrentSet() {
        print("saved current set")
        exerciseHistory?.sets.append(reps)
        updateInformation()
        progressBar.isHidden = false
        isResting = true
        descriptionLabel.text = "Descanso"
        titleLabel.text = "01:00"
        startCountdown()
    }
    
    func getNextExercise() -> Exercise? {
        let currentExerciseIndex = workoutHistory!.workout!.exercises.index(of: exerciseHistory!.exercise!)!
        if currentExerciseIndex + 1 < workoutHistory!.workout!.exercises.count {
            return workoutHistory!.workout!.exercises[currentExerciseIndex + 1]
        }
        return nil
    }
    
    @objc func onContinuePress() {
        if isResting == true {
            progressBar.isHidden = true
            isResting = false
            updateInformation()
            timer?.invalidate()
            return
        }
        
        if !hasMoreSets() {
            guard let nextExercise = getNextExercise() else {
                print("finish workout")
                RealmManager.shared.update {
                    workoutHistory?.concluded = true
                    workoutHistory?.date = Date()
                }
                navigationController?.popViewController(animated: true)
                updateInformation()
                return
            }
            print("next exercise called")
            let nextExerciseHistory = ExerciseHistory()
            nextExerciseHistory.exercise = nextExercise
            exerciseHistory = nextExerciseHistory
            RealmManager.shared.update {
                workoutHistory?.exercises.append(exerciseHistory!)
                workoutHistory?.currentExercise = nextExerciseHistory.id
                updateInformation()
            }
            return
        }
        

        
        print("next set called")
        RealmManager.shared.update {
            saveCurrentSet()
        }
    }
    
    func startCountdown() {
        remainingTime = totalTime
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    // Function to update progress
    @objc func updateProgress() {
        if remainingTime > 0 {
            remainingTime -= 1
            let progress = remainingTime / totalTime
            progressBar.setProgress(progress, animated: true)
            titleLabel.text = "\(progress)"
            let minutes = Int(remainingTime) / 60
            let seconds = Int(remainingTime) % 60
            titleLabel.text = String(format: "%02d:%02d", minutes, seconds)
            
        } else {
            timer?.invalidate()
            timer = nil
            onContinuePress()
        }
    }
}

extension WorkoutProgressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutHistory!.workout!.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: SimpleTableViewCell.self, for: indexPath) as? SimpleTableViewCell else {
            return UITableViewCell()
        }
        let exercise = workoutHistory!.workout!.exercises[indexPath.row]
        cell.configure(title: exercise.name, subTitle: "Series: \(String(exercise.sets))")
        return cell
    }
}

extension WorkoutProgressViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(descriptionLabel)
        view.addSubview(titleLabel)
        view.addSubview(progressBar)
        view.addSubview(setsCard)
        view.addSubview(exerciseButton)
        view.addSubview(exerciseLabel)
        view.addSubview(exercisesTableView)
        view.addSubview(repsCard)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            setsCard.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
            setsCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            setsCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            repsCard.topAnchor.constraint(equalTo: setsCard.bottomAnchor, constant: 10),
            repsCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            repsCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            exerciseButton.heightAnchor.constraint(equalToConstant: 45),
            exerciseButton.topAnchor.constraint(equalTo: repsCard.bottomAnchor, constant: 10),
            exerciseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exerciseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            exerciseLabel.topAnchor.constraint(equalTo: exerciseButton.bottomAnchor, constant: 60),
            exerciseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            exercisesTableView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 10),
            exercisesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exercisesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exercisesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        ])
    }
}

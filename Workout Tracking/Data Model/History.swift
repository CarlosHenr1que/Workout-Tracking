//
//  History.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 19/07/24.
//

import Foundation
import RealmSwift

class ExerciseHistory: Object {
    @Persisted var id = UUID().uuidString
    @Persisted var exercise: Exercise?
    @Persisted var sets = List<Int>()
    
    override static func primaryKey() -> String? {
       return "id"
    }
}

class History: Object {
    @Persisted var id = UUID().uuidString
    @Persisted var exercises = List<ExerciseHistory>()
    @Persisted var workout: Workout?
    @Persisted var date: Date
    @Persisted var concluded: Bool
    @Persisted var currentExercise: String
    
    override static func primaryKey() -> String? {
       return "id"
    }
}

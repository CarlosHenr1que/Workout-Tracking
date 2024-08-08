//
//  Workout.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 13/07/24.
//

import Foundation
import RealmSwift

class Workout: Object {
    @Persisted var id = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var weekday: Int = 0
    @Persisted var exercises = List<Exercise>()
    
    override static func primaryKey() -> String? {
       return "id"
     }
}

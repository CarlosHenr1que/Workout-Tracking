//
//  Exercise.swift
//  Workout Tracking
//
//  Created by Carlos Henrique Matos Borges on 13/07/24.
//


import Foundation
import RealmSwift

class Exercise: Object {
    @Persisted var id = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var sets: Int = 0
    
    override static func primaryKey() -> String? {
       return "id"
     }
}

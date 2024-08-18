//
//  WeekDayHelper.swift
//  Reps Tracking
//
//  Created by Carlos Henrique Matos Borges on 18/03/24.
//

import Foundation

class WeekDayHelper {
    public static let week = ["Domingo", "Segunda", "Terça Feira", "Quarta Feira", "Quinta Feira", "Sexta Feira", "Sabado"]
    
    static func getCurrentWeekday() -> Int {
        let calendar = Calendar.current
        let date = Date()
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday ?? 0
    }
    
    static func getWeekdayText(weekday: Int? = getCurrentWeekday()) -> String? {
        switch (weekday) {
        case 1:
            return "Domingo"
        case 2:
            return "Segunda"
        case 3:
            return "Terça Feira"
        case 4:
            return "Quarta Feira"
        case 5:
            return "Quinta Feira"
        case 6:
            return "Sexta Feira"
        case 7:
            return "Sabado"
        default:
            return nil
        }
    }
}

//
//  Completion.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import Foundation
import SwiftData

@Model
class Completion {
    var date: Date
//    var mood: String = ""

    init(date: Date) {
        self.date = date
    }
}

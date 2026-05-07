//
//  Completion.swift
//  Habits
//
//  Created by Erik on 2026-05-05.
//

import Foundation
import SwiftData

@Model
final class Completion {
    var date: Date
    var count: Int

    init(date: Date, count: Int = 1) {
        self.date = date
        self.count = count
    }
}

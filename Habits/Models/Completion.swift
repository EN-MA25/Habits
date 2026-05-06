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

    init(date: Date) {
        self.date = date
    }
}

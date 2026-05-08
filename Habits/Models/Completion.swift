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
    var numberOfTimesDone: Int

    var latitude: Double?
    var longitude: Double?

    init(
        date: Date,
        count: Int = 1,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.date = date
        self.numberOfTimesDone = count
        self.latitude = latitude
        self.longitude = longitude
    }
}

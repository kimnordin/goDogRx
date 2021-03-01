//
//  SettingsState.swift
//  MoneyTracker
//
//  Created by Kim Nordin on 2020-08-18.
//  Copyright © 2020 Kim Nordin. All rights reserved.
//

import Foundation
import ReSwift

struct SettingsState: StateType {
    var email: String? = nil
    var phone: String? = nil
    var devMode: Bool
    var showMockedApps: Bool
    var manualDelivery: Bool
    var language: Language
}


enum SelectOptions {
    case dev
    case mocked
    case onboard
}

enum Language: String {
    case english = "en"
    case swedish = "sv"
    case deutsch = "de"
    
    static let allValues = [english, swedish, deutsch]
}

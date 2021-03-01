//
//  State.swift
//  MoneyTracker
//
//  Created by Kim Nordin on 2020-08-18.
//  Copyright © 2020 Kim Nordin. All rights reserved.
//

import Foundation
import ReSwift

struct State: StateType {
    let dogState: DogState
    let navigationState: NavigationState
    let settingsState: SettingsState
}

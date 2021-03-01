//
//  DeviceActions.swift
//  MoneyTracker
//
//  Created by Kim Nordin on 2020-08-18.
//  Copyright © 2020 Kim Nordin. All rights reserved.
//

import Foundation
import ReSwift

struct InitialAppState: Action {
    let appState: State
}

struct InitialSettingState: Action {
    let settingState: SettingsState
}

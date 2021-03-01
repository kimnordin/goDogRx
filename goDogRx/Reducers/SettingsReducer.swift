//
//  SettingsReducer.swift
//  FidesmoiOSApp
//
//  Created by Angel Anton on 23/10/2017.
//  Copyright © 2017 Fidesmo. All rights reserved.
//

import Foundation
import ReSwift

func settingsReducer(action: Action, state: SettingsState?) -> SettingsState {
    var state = state ?? initialSettingsState()

    switch action {
    case _ as ReSwiftInit:
        break
    case let action as SetUserEmail:
        state.email = action.email
    case let action as SetUserPhone:
        state.phone = action.phone
    case let action as SwitchDevMode:
        state.devMode = action == .activated
    case let action as InitialSettingState:
        state = action.settingState
    default:
        break
    }
    return state
}

func initialSettingsState() -> SettingsState {
    return SettingsState(email: .none,
                         phone: .none,
                         devMode: false,
                         showMockedApps: false,
                         manualDelivery: false,
                         language: .english)
}

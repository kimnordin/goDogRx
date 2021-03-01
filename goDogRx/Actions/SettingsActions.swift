//
//  SettingActions.swift
//  FidesmoiOSApp
//
//  Created by Angel Anton on 23/10/2017.
//  Copyright © 2017 Fidesmo. All rights reserved.
//

import Foundation
import ReSwift

struct SetUserEmail: Action {
    let email: String
}

struct SetUserPhone: Action {
    let phone: String
}

struct SetAPI: Action {
    let apiAddress: String
}

enum SwitchDevMode: Action {
    case activated
    case deactivated
}

struct SetLanguage: Action {
    let langId: String
}

struct SetViews: Action {
    let numberOfViews: Int
}

//Quick Action Dispatcher for SettingsController
func performAction(section: Int, index: Int, input: String) {
    let point = (section, index)
    switch point {
    case (0, 0):
        store.dispatch(SetUserEmail(email: input))
    case (0, 1):
        store.dispatch(SetUserPhone(phone: input))
    case (1, 0):
        store.dispatch(SetAPI(apiAddress: input))
    default:
        break
    }
}

//
//  NavigationState.swift
//  MoneyTracker
//
//  Created by Kim Nordin on 2020-08-18.
//  Copyright © 2020 Kim Nordin. All rights reserved.
//

import Foundation
import ReSwift

struct NavigationState: StateType {
    var command: Command
    var route: RoutingDestination
    var history: [RoutingDestination]
}

enum Command {
    case goForward
    case goBack
}

enum RoutingDestination {
    case mydogs
    case newdog
    case dog
    case profile

    enum MenuOption: Int {
        case appStore = 0
        case settings = 1
        case manualDelivery = 2
    }
}

extension RoutingDestination: Equatable {
    static func == (lhs: RoutingDestination, rhs: RoutingDestination) -> Bool {
        switch (lhs, rhs) {
        case (.mydogs, .mydogs):
            return true
        case (.newdog, .newdog):
            return true
        case (.dog, .dog):
            return true
        case (.profile, .profile):
            return true
        default:
            return false
        }
    }
}

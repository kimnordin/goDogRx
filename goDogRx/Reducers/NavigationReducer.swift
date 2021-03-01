//
//  RoutingReducer.swift
//  FidesmoiOSApp
//
//  Created by Angel Anton on 08/11/2017.
//  Copyright © 2017 Fidesmo. All rights reserved.
//

import Foundation
import ReSwift
import CoreData

func navigationReducer(action: Action, state: NavigationState?) -> NavigationState {
    var state = state ?? initialNavigationState()

    switch action {
    case let action as NavigateTo:
        print("nav to: ", action.destination)
        state.history.append(state.route)
        state.route = action.destination
        state.command = .goForward
    case is NavigateBack:
        print("nav back")
        if let lastRoute = state.history.popLast() {
            state.route = lastRoute
            state.command = .goBack
        }
    case let action as InitialAppState:
        state = action.appState.navigationState
    default: break
    }
    return state
}

func initialNavigationState() -> NavigationState {
    return NavigationState(command: .goForward, route: .mydogs, history: [RoutingDestination]())
}



//
//  AppReducer.swift
//  MoneyTracker
//
//  Created by Kim Nordin on 2020-08-18.
//  Copyright © 2020 Kim Nordin. All rights reserved.
//

import Foundation
import ReSwift

func appReducer(action: Action, state: State?) -> State {
    return State(dogState: dogReducer(action: action, state: state?.dogState), navigationState: navigationReducer(action: action, state: state?.navigationState),
        settingsState: settingsReducer(action: action, state: state?.settingsState))
}

func combineReducers<T>(_ first: @escaping Reducer<T>, _ remainder: Reducer<T>...) -> Reducer<T> {
    return { action, state in
        let firstResult = first(action, state)
        let result = remainder.reduce(firstResult) { result, reducer in
            return reducer(action, result)
        }
        return result
    }
}

//let combinedReducer: Reducer<DeviceManagerState> = combineReducers(deviceListReducer, appListReducer)

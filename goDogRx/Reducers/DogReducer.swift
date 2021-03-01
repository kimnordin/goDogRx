//
//  DogReducer.swift
//  goDog
//
//  Created by Kim Nordin on 2020-08-29.
//  Copyright © 2020 kim. All rights reserved.
//

import Foundation
import ReSwift

func dogReducer(action: Action, state: DogState?) -> DogState {
    var state = state ?? initialDogState()

    switch action {
    case _ as ReSwiftInit:
        break
    case let action as AddDog:
        state.dogs.append(action.dog)
    case let action as DeleteDog:
        state.dogs.remove(at: action.index)
    case let action as SetActiveDog:
        state.selectedDog = action.position
    case let action as SetName:
        state.activeDog()?.name = action.name
    case let action as NavigateTo:
        if action.destination == .mydogs {
            state.selectedDog = -1
        }
    case is NavigateBack:
        let navState = store.state.navigationState
        if navState.route == .dog {
            state.selectedDog = -1
        }
    case let action as InitialDogState:
        state = action.state.dogState
    default:
        break
    }
    return state
}

func initialDogState() -> DogState {
    return DogState(dogs: [], selectedDog: -1)
}

extension DogState {
    func activeDog() -> Dog? {
        if selectedDog == -1 || selectedDog >= dogs.count {
            print("none")
            return .none
        }
        return dogs[selectedDog]
    }

//    func getModelById(deviceId: DeviceId) -> DeviceModel? {
//        return deviceList.first { model in model.deviceId == deviceId }
//    }
}

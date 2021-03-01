//
//  DogActions.swift
//  goDog
//
//  Created by Kim Nordin on 2020-08-29.
//  Copyright © 2020 kim. All rights reserved.
//

import Foundation
import ReSwift

struct AddDog: Action {
    let dog: Dog
}

struct DeleteDog: Action {
    let index: Int
}

struct SetActiveDog: Action {
    let position: Int
}

struct SetName: Action {
    let name: String
}

struct SetImage: Action {
    let image: UIImage
}

struct SetFirstTimer: Action {
    let time: String
}

struct SetSecondTimer: Action {
    let time: String
}

struct SetWalking: Action {
    let walking: Bool
}

struct AddWalk: Action {
    let walk: Walk
}

struct RemoveWalk: Action {
    let at: Int
}

struct SetFirstSelection: Action {
    let selected: Bool
}

struct SetSecondSelection: Action {
    let selected: Bool
}

struct SetFirstDate: Action {
    let date: Date
}

struct SetSecondDate: Action {
    let date: Date
}

struct InitialDogState: Action {
    let state: State
}

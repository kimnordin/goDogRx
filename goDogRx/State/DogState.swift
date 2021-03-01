//
//  DogState.swift
//  goDog
//
//  Created by Kim Nordin on 2020-08-29.
//  Copyright © 2020 kim. All rights reserved.
//

import Foundation
import ReSwift

struct DogState: StateType {
    var dogs: [Dog]
    var selectedDog: Int
}

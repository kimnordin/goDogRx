//
//  RoutingAction.swift
//  FidesmoiOSApp
//
//  Created by Angel Anton on 08/11/2017.
//  Copyright © 2017 Fidesmo. All rights reserved.
//

import Foundation
import ReSwift

struct NavigateTo: Action {
    let destination: RoutingDestination
}

struct NavigateBack: Action {
}

enum ChangeMenuTo: Action {
    case show
    case hide
}

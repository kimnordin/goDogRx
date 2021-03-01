//
//  DogManager.swift
//  goDog
//
//  Created by Kim Nordin on 2020-04-27.
//  Copyright © 2020 kim. All rights reserved.
//

import Foundation
import RealmSwift

//  DogListModel
class DogListObject: Object { //  State
    let dogModel = List<DogObject>()
}

//  DogModel
class DogObject: Object {
    let deviceState = LinkingObjects(fromType: DogListObject.self, property: "dogModel")
    @objc dynamic var name = ""
    @objc dynamic var image = ""
    @objc dynamic var firstTimer: String?
    @objc dynamic var secondTimer: String?
    @objc dynamic var walking: Bool = false
    let walkModel = List<WalkObject>()
    @objc dynamic var firstSelect: Bool = false
    @objc dynamic var secondSelect: Bool = false
    @objc dynamic var firstDate: Date?
    @objc dynamic var secondDate: Date?
//    @objc dynamic var id = ""
}

//  WalkModel
class WalkObject: Object {
    let deviceState = LinkingObjects(fromType: DogObject.self, property: "walkModel")
    @objc dynamic var time = ""
    @objc dynamic var distance: Double = 0.0
    @objc dynamic var firstAction: Bool = false
    @objc dynamic var secondAction: Bool = false
}

class ProfileObject: Object {
    @objc dynamic var firstField: String?
    @objc dynamic var secondField: String?
    @objc dynamic var firstColor: String?
    @objc dynamic var secondColor: String?
}

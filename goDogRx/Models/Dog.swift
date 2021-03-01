//
//  DogEntry.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-10.
//  Copyright © 2019 kim. All rights reserved.
//

import Foundation
import UIKit

class Dog {
    
    var name: String
    var image: UIImage
    var firstTimer: String?
    var secondTimer: String?
    var walking: Bool = false
    var walkArray = [Walk]()
    var firstSelect: Bool?
    var secondSelect: Bool?
    var firstDate: Date?
    var secondDate: Date?
    
    init(name: String, image: UIImage, firstTimer: String, secondTimer: String, walking: Bool, walkArray: [Walk], firstSelect: Bool?, secondSelect: Bool?, firstDate: Date?, secondDate: Date?) {
        self.name = name
        self.image = image
        self.firstTimer = firstTimer
        self.secondTimer = secondTimer
        self.walking = walking
        self.walkArray = walkArray
        self.firstSelect = firstSelect
        self.secondSelect = secondSelect
        self.firstDate = firstDate
        self.secondDate = secondDate
   }
    
    func toAny() -> [String: Any] {
        return ["name": name, "image": image, "firstTimer": firstTimer, "secondTimer": secondTimer, "walking": walking, "walkArray": walkArray, "firstSelect": firstSelect, "secondSelect": secondSelect, "firstDate": firstDate, "secondDate": secondDate]
    }
}

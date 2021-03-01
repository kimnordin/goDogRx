//
//  Profile.swift
//  goDog
//
//  Created by Kim Nordin on 2020-05-11.
//  Copyright © 2020 kim. All rights reserved.
//

import Foundation
import UIKit

class Profile {
    var firstField: String?
    var secondField: String?
    var firstColor: UIColor?
    var secondColor: UIColor?
    
    init(firstField: String, secondField: String, firstColor: UIColor, secondColor: UIColor) {
        self.firstField = firstField
        self.secondField = secondField
        self.firstColor = firstColor
        self.secondColor = secondColor
   }
    
    func toAny() -> [String: Any] {
        return ["firstField": firstField, "secondField":secondField, "firstColor": firstColor, "secondColor": secondColor]
    }
}

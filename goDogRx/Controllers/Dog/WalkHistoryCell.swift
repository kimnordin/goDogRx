//
//  WalkHistoryCell.swift
//  goDog
//
//  Created by Kim Nordin on 2020-02-21.
//  Copyright © 2020 kim. All rights reserved.
//

import UIKit

class WalkHistoryCell: UITableViewCell {
    
    var profile = (UIApplication.shared.delegate as! AppDelegate).profile

    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var distanceDisplay: UILabel!
    @IBOutlet weak var firstDisplay: UILabel!
    @IBOutlet weak var secondDisplay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        firstDisplay.backgroundColor = profile?.firstColor ?? UIColor.systemTeal
        secondDisplay.backgroundColor = profile?.secondColor ?? UIColor.systemPink
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

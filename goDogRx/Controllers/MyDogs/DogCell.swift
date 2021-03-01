//
//  DogCell.swift
//  goDog
//
//  Created by Kim Nordin on 2020-02-19.
//  Copyright © 2020 kim. All rights reserved.
//

import UIKit

class DogCell: UITableViewCell {
    
    var profile = (UIApplication.shared.delegate as! AppDelegate).profile

    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogStatus: UILabel!
    @IBOutlet weak var dogTimer: UILabel!
    @IBOutlet weak var insetView: UIView!
    @IBOutlet weak var firstIcon: UILabel!
    @IBOutlet weak var secondIcon: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        firstIcon.backgroundColor = profile?.firstColor
        secondIcon.backgroundColor = profile?.secondColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

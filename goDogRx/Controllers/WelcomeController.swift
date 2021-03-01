//
//  WelcomeController.swift
//  goDog
//
//  Created by Kim Nordin on 2020-02-19.
//  Copyright © 2020 kim. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = 30
        startButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

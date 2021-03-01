//
//  ColorTableController.swift
//  goDog
//
//  Created by Kim Nordin on 2020-05-11.
//  Copyright © 2020 kim. All rights reserved.
//

import UIKit

class ColorTableController: UITableViewController {

    let cellId = "ColorCell"
    var colorArray = [String]()
    var coloRay = [UIColor]()
    var footer = UIView()
    var firstColor = UIColor.systemTeal
    var secondColor = UIColor.systemPink
    var sender: UIView?
    
    private var kvoContext = 0 //Key Value Observer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = coloRay.first
        colorArray = self.fetchColorDataArray()
        for hex in colorArray {
            coloRay.append(UIColor.init(hexString: hex))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nib = UINib(nibName: "ColorCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ColorCell")
        let viewHeight = coloRay.count * 30
        print(viewHeight)
        self.preferredContentSize = CGSize(width: 200, height: viewHeight)
    }
    
    func fetchColorDataArray()->[String]{
        if let path = Bundle.main.path(forResource: "Colors", ofType: "plist") {
            if let color = NSArray(contentsOfFile: path) {
                return color as! [String]

            }
        }
        return []
    }

    override func viewDidDisappear(_ animated: Bool) {
        //Remove observer when view is resigned to prevent leak
        super.viewDidDisappear(animated)
    }
    
    // Dismiss the ColorController if you exit the app
    @objc private func reloadInterface() {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    // Fetch all cells and add their height to the preferredContentSize of the ViewController

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coloRay.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sender?.backgroundColor = coloRay[indexPath.row]
        if (sender?.tag == 1) {
            firstColor = coloRay[indexPath.row]
        }
        else if (sender?.tag == 2) {
            secondColor = coloRay[indexPath.row]
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ColorCell

        cell.backView.backgroundColor = coloRay[indexPath.row]
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .default
        cell.isUserInteractionEnabled = true
        
        return cell
    }
}

//
//  ProfileController.swift
//  goDog
//
//  Created by Kim Nordin on 2020-05-11.
//  Copyright © 2020 kim. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var secondField: UITextField!
    @IBOutlet weak var firstItem: UIButton!
    @IBOutlet weak var secondItem: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var profile = (UIApplication.shared.delegate as! AppDelegate).profile
    
    var firstColor = UIColor.systemTeal
    var secondColor = UIColor.systemPink
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//  Setup the UI
        firstField.text = profile?.firstField
        secondField.text = profile?.secondField
        firstItem.setTitle(profile?.firstField, for: .normal)
        secondItem.setTitle(profile?.secondField, for: .normal)
        firstItem.backgroundColor = profile?.firstColor ?? firstColor
        secondItem.backgroundColor = profile?.secondColor ?? secondColor
        firstItem.layer.cornerRadius = firstItem.frame.height/2
        secondItem.layer.cornerRadius = secondItem.frame.height/2
        firstItem.layer.masksToBounds = true
        secondItem.layer.masksToBounds = true
    }
    
    @IBAction func navigateMyDogs(_ sender: UIBarButtonItem) {
        store.dispatch(NavigateTo(destination: .mydogs))
    }
    
    @IBAction func colorSelectAction(_ sender: UIButton) {
        popContextView(view: sender)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        if firstField.text != "" && firstField.text != profile?.firstField {
            profile?.firstField = firstField.text
            firstItem.setTitle(profile?.firstField, for: .normal)
        }
        if secondField.text != "" && secondField.text != profile?.secondField {
            profile?.secondField = secondField.text
            secondItem.setTitle(profile?.secondField, for: .normal)
        }
        profile?.firstColor = firstItem.backgroundColor
        profile?.secondColor = secondItem.backgroundColor
    }
    @IBAction func defaultAction(_ sender: UIButton) {
        profile?.firstField = "#1"
        profile?.secondField = "#2"
        profile?.firstColor = UIColor.systemTeal
        profile?.secondColor = UIColor.systemPink
        
        firstField.text = profile?.firstField
        secondField.text = profile?.secondField
        firstItem.setTitle(profile?.firstField, for: .normal)
        secondItem.setTitle(profile?.secondField, for: .normal)
        firstItem.backgroundColor = profile?.firstColor
        secondItem.backgroundColor = profile?.secondColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstField.resignFirstResponder()
        secondField.resignFirstResponder()
        return true
    }
}

@available(iOS 11.0, *)
extension ProfileController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

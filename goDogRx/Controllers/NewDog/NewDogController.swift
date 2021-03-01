//
//  NewDogController.swift
//  goDog
//
//  Created by Kim Nordin on 2020-02-19.
//  Copyright © 2020 kim. All rights reserved.
//

import UIKit

class NewDogController: UIViewController, UITextFieldDelegate {
    
    var imageSet = false

    @IBOutlet weak var dogImagePreview: UIButton!
    @IBOutlet weak var dogName: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dogName.delegate = self
        dogImagePreview.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)
        dogName.attributedPlaceholder = NSAttributedString(string: "Dog Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Gray")?.withAlphaComponent(0.45)])

        dogImagePreview.imageView?.contentMode = .scaleAspectFill
        dogName.text = nil
        isEditing = false
        saveButton.layer.cornerRadius = 30
        cancelButton.layer.cornerRadius = 30
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0).cgColor
        if(!UIAccessibility.isReduceTransparencyEnabled) {
            blur()
        }
        else {
            backView.backgroundColor = UIColor(named: "Dark")
        }
        dogName.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    func blur() {
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.regular)
        
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = backView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backView.addSubview(blurView)
    }
    
    func canCreateDog() -> Bool {
        if dogName.text == "" || imageSet == false {
            return false
        }
        else { return true }
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        openGallery(vc: self)
    }
    @IBAction func cancelDog(_ sender: UIButton) {
        store.dispatch(NavigateTo(destination: .mydogs))
    }
    @IBAction func saveDog(_ sender: UIButton) {

        if(canCreateDog() == true) {
            if let name = dogName.text,
            let image = dogImagePreview.imageView?.image {
                let dog = Dog(name: name, image: image, firstTimer: "", secondTimer: "", walking: false, walkArray: [], firstSelect: false, secondSelect: false, firstDate: nil, secondDate: nil)
                store.dispatch(AddDog(dog: dog))
                print("Created Dog: ", dog.name)
// self.performSegue(withIdentifier: "dogRewind", sender: self)
                store.dispatch(NavigateTo(destination: .mydogs))
            }
        }
        else {
            let alert = UIAlertController(title: "Missing requirement", message: "Dog needs an image and a name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        print("default")
                  case .cancel:
                        print("cancel")
                  case .destructive:
                        print("destructive")
            }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageSet = true
            dogImagePreview.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dogName.resignFirstResponder()
        return true
    }
}

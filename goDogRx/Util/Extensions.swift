//
//  Extensions.swift
//  goDog
//
//  Created by Kim Nordin on 2020-02-23.
//  Copyright © 2020 kim. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

//Types
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.jpegData(compressionQuality: 0.1)
        return data?.base64EncodedString(options: .lineLength64Characters)
    }
}

extension UIColor {
    convenience init(hexString:String) {
        let scanner = Scanner(string: hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}

extension Data
{
    func toString() -> String?
    {
        return String(data: self, encoding: .utf8)
    }
}

//UIViews
extension UIViewController {
    func popContextView(view: UIView) { //Instantiate a Contextual Menu as a PopVC
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "colorVC") as? ColorTableController else { return }
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self as? UIPopoverPresentationControllerDelegate //Check that PopVC caller is a popover delegate
        popVC.sender = view
        popOverVC?.sourceView = view // Origin of pop is the view that called it
        popOverVC?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 1)
        popOverVC?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        self.present(popVC, animated: true)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // Allows dismissal by swipe on the VC that called this function
    func swipeDismiss() {
        let gesture = GestureRecognizerManager(target: self, action: #selector(dismiss(fromGesture:)))
        view.addGestureRecognizer(gesture)
    }
    @objc func dismiss(fromGesture gesture: GestureRecognizerManager) {
        let navState = store.state.navigationState
        let history = navState.history
        let valid = history.indices.contains(history.count-1) // Prevent array out-of-bounds
        if valid {
//            if(navState.route == .delivery) {
//                if let appId = store.state.selectedAppState.selectedApp {
//                    store.dispatch(RefreshAppExtraInfo(appId: appId))
//                    store.dispatch(RefreshAvailableServices(appId: appId))
//                }
//            }
            store.dispatch(NavigateBack())
        }
    }
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openGallery(vc: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = vc
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            vc.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access the gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

//
//  DogController.swift
//  goDog
//
//  Created by Kim Nordin on 2020-02-21.
//  Copyright © 2020 kim. All rights reserved.
//

import UIKit
import ReSwift
import CoreMotion

class DogController: UIViewController, UITextFieldDelegate, StoreSubscriber {
    
    @IBOutlet weak var timerTable: UITableView!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var changeDogImage: UIButton!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var latestWalkDisplay: UILabel!
    @IBOutlet weak var dogNameEdit: UITextField!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var firstActionButton: UIButton!
    @IBOutlet weak var secondActionButton: UIButton!
    @IBOutlet weak var topShadowView: UIView!
    @IBOutlet weak var bottomShadowView: UIView!
    
    var cellHeight = 85
    var walkData: Double = 0
    var edit = false
    var imageSet = false
    
    var dog: Dog?
    var profile = (UIApplication.shared.delegate as! AppDelegate).profile

    let calendar = Calendar.current
    let format = DateFormatter()
    let cellId = "historyTableCell"
    let segueId = "walkHistorySegue"
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    var pastDate: Date?
    var nowDate: Date?

    // * Checks if the dog is walking or not, since the timer button should conform to that with "Start"-ing or "Stop"-ing * //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dogNameEdit.delegate = self
        timerTable.delegate = self
        timerTable.dataSource = self
        timerTable.separatorColor = UIColor(named: "Light")
        firstActionButton.setTitle(profile?.firstField, for: .normal)
        secondActionButton.setTitle(profile?.secondField, for: .normal)
        dogNameEdit.isHidden = true
        dogImageView.layer.cornerRadius = dogImageView.frame.width/2
        dogImageView.layer.borderWidth = 2.0
        dogImageView.layer.borderColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0).cgColor
        walkButton.layer.cornerRadius = walkButton.frame.height/2
        walkButton.layer.masksToBounds = true
        firstActionButton.backgroundColor = profile?.firstColor ?? UIColor.systemPink
        secondActionButton.backgroundColor = profile?.secondColor ?? UIColor.systemPink
        firstActionButton.layer.cornerRadius = firstActionButton.frame.height/2
        secondActionButton.layer.cornerRadius = secondActionButton.frame.height/2
        firstActionButton.layer.masksToBounds = true
        secondActionButton.layer.masksToBounds = true
        changeDogImage.layer.cornerRadius = changeDogImage.frame.height/2
        changeDogImage.layer.masksToBounds = true
        changeDogImage.isHidden = true
        
        nowDate = Date()
        
        // * Style the button depending on the Status of the Dog * //
        
        
        setIfSelected()

        store.subscribe(self) { subscription in
            subscription.select { state in state.dogState }
        }
    }
    
    
    @IBAction func navigateMyDogs(_ sender: UIBarButtonItem) {
        store.dispatch(NavigateTo(destination: .mydogs))
    }
    
    func newState(state: DogState) {
        DispatchQueue.main.async {
            if let activeDog = state.activeDog() {
                
                self.dog = activeDog
                
                if activeDog.walking == true {
                    self.latestWalkDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
                    self.walkButton.setTitle("Stop", for: .normal)
                    self.latestWalkDisplay.text = activeDog.firstTimer
                }
                else if activeDog.walking == false {
                    self.latestWalkDisplay.textColor = UIColor(named: "Light")
                    self.latestWalkDisplay.text = activeDog.walkArray.first?.time
                }
                
                self.title = activeDog.name // Set NavBar Title to match Dogs name
                self.dogName.text = activeDog.name
                self.dogImageView.image = activeDog.image
                
                self.styleShadowsDependingOnListLength(dog: activeDog)
            }
        }
    }
    
    func styleShadowsDependingOnListLength(dog: Dog) {
        if dog.walkArray.isEmpty {
            styleShadowBorders(top: false, bottom: false)
        }
        else if(CGFloat(dog.walkArray.count * cellHeight) >= timerTable.frame.height) {
            styleShadowBorders(top: true, bottom: true)
        }
        else if(!dog.walkArray.isEmpty && CGFloat(dog.walkArray.count * cellHeight) < timerTable.frame.height) {
            styleShadowBorders(top: true, bottom: false)
        }
    }
    
    func styleShadowBorders(top: Bool, bottom: Bool) {
        if top {
            topShadowView.layer.shadowColor = UIColor(named: "Light")?.cgColor
            topShadowView.layer.shadowOffset = CGSize(width: 0, height: 10)
            topShadowView.layer.shadowRadius = 5
            topShadowView.layer.shadowOpacity = 0.1
        }
        else if !top {
            topShadowView.layer.shadowColor = UIColor.clear.cgColor
        }
        if bottom {
            bottomShadowView.layer.shadowColor = UIColor(named: "Light")?.cgColor
            bottomShadowView.layer.shadowOffset = CGSize(width: 0, height: -10)
            bottomShadowView.layer.shadowRadius = 5
            bottomShadowView.layer.shadowOpacity = 0.1
        }
        else if !bottom {
            bottomShadowView.layer.shadowColor = UIColor.clear.cgColor
        }
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13, *), self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            topShadowView.layer.shadowColor = UIColor(named: "Light")?.cgColor
            bottomShadowView.layer.shadowColor = UIColor(named: "Light")?.cgColor
            // re-set cgColors on light/dark mode
        }
    }
    
    func isFirstSelected() -> Bool {
        if dog?.firstSelect == true {
            return true
        }
        else if dog?.firstSelect == false { return false }
        return false
    }
    
    func isSecondSelected() -> Bool {
        if dog?.secondSelect == true {
            return true
        }
        else if dog?.secondSelect == false { return false }
        return false
    }
    
    private func updateActivity() {
        print("update activity!")
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        }
    }
    
    func startCountingSteps() -> Double {
        pedometer.queryPedometerData(from: (pastDate ?? dog?.secondDate) ?? Date(), to: nowDate ?? dog?.firstDate ?? Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                print(pedometerData.distance?.stringValue)
                if let returnedData = pedometerData.distance?.doubleValue {
                    self?.walkData = returnedData
                }
            }
        }
        return walkData
    }
    
    private func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    print("Walking")
                } else if activity.stationary {
                    print("Stationary")
                } else if activity.running {
                    print("Running")
                } else if activity.automotive {
                    print("Automotive")
                }
            }
        }
    }
    
    func stopActivity() {
        pedometer.stopUpdates()
        walkData = 0.0
        nowDate = nil
        pastDate = nil
    }
    
    func formattedDistanceForMeters(distance: Double) -> String {
        var stringDistance = ""
        if distance >= 100 {
            if NSLocale.current.usesMetricSystem
            {
                stringDistance = String((distance / 1000).truncate(places: 3))
                stringDistance += "km"
            }
            else
            {
                stringDistance = String((distance / 1609.34).truncate(places: 3))
                stringDistance += "mi"
            }
        }
        else {
            stringDistance = String(distance)
            if NSLocale.current.usesMetricSystem
            {
                stringDistance = String(distance.truncate(places: 1))
                stringDistance += "m"
            }
            else {
                stringDistance = String(distance.truncate(places: 1))
                stringDistance += "ft"
            }
        }
        return stringDistance
    }
    
    @IBAction func walkAction(_ sender: UIButton) {
        format.dateFormat = "HH:mm"
        let formattedDate = format.string(from: Date())
        //      Started Walking
        if dog?.walking == false {
            pastDate = Date()
            dog?.secondDate = pastDate
            dog?.firstTimer = (formattedDate)
            latestWalkDisplay.text = dog?.firstTimer
            latestWalkDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
            walkButton.setTitle(NSLocalizedString("Stop", comment: "Stop"), for: .normal)
            firstActionButton.isHidden = false
            secondActionButton.isHidden = false
            dog?.walking = true
        }
        //      Stopped Walking
        else if dog?.walking == true {
            walkButton.isEnabled = false
            firstActionButton.isHidden = true
            secondActionButton.isHidden = true
            nowDate = Date()
            updateActivity()
            dog?.firstDate = nowDate
            dog?.secondTimer = (formattedDate)
            if let firstTime = dog?.firstTimer,
               let secondTime = dog?.secondTimer {
                let alert = UIAlertController(title: "Save walk?", message: "Do you want to remember this walk?" + (firstTime) + " | " + (secondTime), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                    let combinedTime = ((firstTime) + " | " + (secondTime))
                    self.latestWalkDisplay.text = combinedTime
                    self.latestWalkDisplay.textColor = UIColor(named: "Light")
                    let newWalk = Walk(time: combinedTime, distance: self.walkData, firstAction: self.dog?.firstSelect, secondAction: self.dog?.secondSelect)
                    self.dog?.walkArray.insert(newWalk, at: 0)
                    self.timerTable.reloadData()
                    
                    // Puts new timers at the top of the Table
                    let topIndex = IndexPath(row: 0, section: 0)
                    self.timerTable.scrollToRow(at: topIndex, at: .top, animated: true)
                    self.dog?.firstTimer = (formattedDate)
                    self.dog?.firstSelect = false
                    self.dog?.secondSelect = false
                    self.stopActivity()
                }))
                alert.addAction(UIAlertAction(title: "Don't save", style: .cancel, handler: { action in
                    self.latestWalkDisplay.text = nil
                    self.dog?.firstSelect = false
                    self.dog?.secondSelect = false
                    self.stopActivity()
                }))
                self.present(alert, animated: true)
                dog?.walking = false
                walkButton.setTitle("", for: .normal)
                self.walkButton.isEnabled = true
                walkButton.setTitle(NSLocalizedString("Walk", comment: "Walk"), for: .normal)
            }
        }
        setIfSelected()
    }
    
//    Style (if walking) or hide (not walking) depending on saved data
    func setIfSelected() {
        if(dog?.walking == true) {
            styleButtonOnSelection()
        }
        else if(dog?.walking == false) {
            firstActionButton.alpha = 1.0
            secondActionButton.alpha = 1.0
            firstActionButton.isHidden = true
            secondActionButton.isHidden = true
        }
    }
    
//    Style #1 and #2 button alpha depending on saved selection
    func styleButtonOnSelection() {
        if(dog?.firstSelect == true) {
            firstActionButton.alpha = 1.0
        }
        else if(dog?.firstSelect == false) {
            firstActionButton.alpha = 0.7
        }
        if(dog?.secondSelect == true) {
            secondActionButton.alpha = 1.0
        }
        else if(dog?.secondSelect == false) {
            secondActionButton.alpha = 0.7
        }
    }
    
    @IBAction func firstAction(_ sender: UIButton) {
        if dog?.firstSelect == false {
            dog?.firstSelect = true
        }
        else if dog?.firstSelect == true {

            dog?.firstSelect = false
        }
        styleButtonOnSelection()
    }
    
    @IBAction func secondAction(_ sender: UIButton) {
        if dog?.secondSelect == false {
            dog?.secondSelect = true
        }
        else if dog?.secondSelect == true  {
            dog?.secondSelect = false
        }
        styleButtonOnSelection()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        if let presenter = presentingViewController as? MyDogsController {
        }
    }
    @IBAction func editDogImageAction(_ sender: UIButton) {
        openGallery(vc: self)
    }
    
    @IBAction func editDog(_ sender: UIBarButtonItem) {
        edit = !edit
        
        if edit {
            changeDogImage.isHidden = false
            dogNameEdit.text = dogName.text
            dogName.isHidden = true
            dogNameEdit.isHidden = false
            editButton.title = "Save"
        }
        else if !edit {
            changeDogImage.isHidden = true
            dogName.isHidden = false
            dogNameEdit.isHidden = true
            editButton.title = "Edit"
            dogNameEdit.resignFirstResponder()
            
            if let name = self.dogNameEdit.text {
                self.title = name
                dogName.text = name
                dog?.name = name
            }
            if imageSet == true {
                if let newImage = dogImageView.image {
                    print("image set")
                    dog?.image = newImage
                }
            }
            dogNameEdit.text = ""
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dogNameEdit.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageSet = true
            dogImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
}


extension DogController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let thisDog = dog {
            styleShadowsDependingOnListLength(dog: thisDog)
        }
        return dog?.walkArray.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Performs the Delete Action on select
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            self.dog?.walkArray.remove(at: indexPath.row)
            self.timerTable.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = UIColor.red
        return action
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timerTable.dequeueReusableCell(withIdentifier: "historyTableCell", for: indexPath) as! WalkHistoryCell
        let cellDist = formattedDistanceForMeters(distance: dog?.walkArray[indexPath.row].distance ?? 0.0)
        cell.distanceDisplay.text = cellDist
        cell.timeDisplay.text = dog?.walkArray[indexPath.row].time ?? ""
        if dog?.walkArray[indexPath.row].firstAction == true {
            cell.firstDisplay.isHidden = false
        }
        else if dog?.walkArray[indexPath.row].firstAction == false {
            cell.firstDisplay.isHidden = true
        }
        if dog?.walkArray[indexPath.row].secondAction == true {
            cell.secondDisplay.isHidden = false
        }
        else if dog?.walkArray[indexPath.row].secondAction == false {
            cell.secondDisplay.isHidden = true
        }

        return cell
    }
    //
    //    // * CURRENTLY NOT IN USE * //
    //    @IBAction func shareDog(_ sender: UIButton) {
    //        if thisDog?.shareId == "" && thisDog?.shared == false {
    //            guard let user = auth.currentUser else {return}
    //            let publicRef = db.collection("public-dogs")
    //            let uuid = UUID().uuidString
    //
    //            if let dogId = thisDog?.id {
    //                thisDog?.shared = true
    //                let dogsRef = db.collection("users").document(user.uid).collection("dogs").document(dogId)
    //                dogsRef.updateData(["shareId" : uuid])
    //                let dog = DogEntry(name: thisDog?.name ?? "", image: thisDog?.image ?? "", firstTimer: thisDog?.firstTimer ?? "", secondTimer: thisDog?.secondTimer ?? "", walking: thisDog?.walking ?? false, walkArray: thisDog?.walkArray ?? [""], distArray: thisDog?.distArray ?? [""], shareId: uuid, shared: true)
    //
    //                publicRef.addDocument(data: dog.toAny())
    //                guard let name = thisDog?.name else {
    //                    return
    //                }
    //
    //                let alert = UIAlertController(title: "\(name) shared!", message: "Access Code: \(uuid)", preferredStyle: .alert)
    //                alert.addAction(UIAlertAction(title: "Copy ID", style: .default, handler: { action in
    //                    self.copyToClipboard(text: uuid)
    //                }))
    //                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //                self.present(alert, animated: true)
    //            }
    //        }
    //        else {
    //            guard let name = thisDog?.name else {
    //                return
    //            }
    //            guard let id = thisDog?.shareId else {
    //                return
    //            }
    //            let alert = UIAlertController(title: "\(name) shared!", message: "Access Code: \(id)", preferredStyle: .alert)
    //            alert.addAction(UIAlertAction(title: "Copy ID", style: .default, handler: { action in
    //                self.copyToClipboard(text: id)
    //            }))
    //            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //            self.present(alert, animated: true)
    //        }
    //    }
}

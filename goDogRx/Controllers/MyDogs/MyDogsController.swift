//
//  MyDogsController.swift
//  goDog
//
//  Created by Kim Nordin on 2020-02-19.
//  Copyright © 2020 kim. All rights reserved.
//

import UIKit
import ReSwift
class MyDogsController: UIViewController, StoreSubscriber {
    
    var dogs = [Dog]()
    var cellFirstColor = UIColor.systemTeal
    var cellSecondColor = UIColor.systemPink

    @IBOutlet weak var dogTable: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        dogTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogTable.delegate = self
        dogTable.dataSource = self
        dogTable.separatorColor = UIColor(named: "Light")
        store.subscribe(self) { subscription in
            subscription.select { state in state.dogState }
        }
    }
    @IBAction func navigateProfile(_ sender: UIBarButtonItem) {
        store.dispatch(NavigateTo(destination: .profile))
    }
    @IBAction func navigateAddDog(_ sender: UIBarButtonItem) {
        store.dispatch(NavigateTo(destination: .newdog))
    }
    func newState(state: DogState) {
        self.dogs = state.dogs
        print("new state")
        DispatchQueue.main.async {
            if (state.selectedDog != -1 && state.activeDog() != nil) {
                print("valid state to navigate")
                store.dispatch(NavigateTo(destination: .dog))
            }
        }
    }
}

extension MyDogsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0 //Choose your custom row height
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Performs the Delete Action on select
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            store.dispatch(DeleteDog(index: indexPath.row))
            self.dogTable.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = UIColor.red
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(SetActiveDog(position: indexPath.row))
    }
    
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dogTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DogCell
        
        let thisDog = dogs[indexPath.row]
        
        cell.dogName.text = thisDog.name
        cell.dogImage.image = thisDog.image
        
        cell.firstIcon.isHidden = true
        cell.secondIcon.isHidden = true
        
        cell.firstIcon.layer.masksToBounds = true
        cell.secondIcon.layer.masksToBounds = true
        
        cell.firstIcon.layer.cornerRadius = cell.firstIcon.frame.height/2
        cell.secondIcon.layer.cornerRadius = cell.secondIcon.frame.height/2
        
        // Each dog (cell) display their timer/timers depending on if the dog is walking/has walked
        if thisDog.walking == true {
            cell.dogStatus.text = "Walking"
            cell.dogTimer.text = thisDog.firstTimer ?? ""
            cell.dogTimer.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
            if thisDog.firstSelect == true {
                cell.firstIcon.isHidden = false
            }
            if thisDog.secondSelect == true {
                cell.secondIcon.isHidden = false
            }
        }
        else if thisDog.walking == false {
            if !thisDog.walkArray.isEmpty {
                cell.dogTimer.text = thisDog.walkArray[0].time
            }
            else {
                cell.dogTimer.text = ":"
            }
            cell.dogTimer.textColor = UIColor(named: "Light")
            cell.dogStatus.text = "Latest Walk"
            
            if thisDog.walkArray.first?.firstAction == true {
                cell.firstIcon.isHidden = false
            }
            if thisDog.walkArray.first?.secondAction == true {
                cell.secondIcon.isHidden = false
            }
        }

        cell.dogImage.layer.cornerRadius = cell.dogImage.frame.width/2
        cell.dogImage.layer.borderWidth = 2.0
        cell.dogImage.layer.borderColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0).cgColor
        cell.dogImage.layer.masksToBounds = true
        
        return cell
    }
}


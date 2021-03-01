//
//  AppDelegate.swift
//  goDogRx
//
//  Created by Kim Nordin on 2021-01-12.
//

import UIKit
import RealmSwift
import ReSwift

var store = Store<State>(reducer: appReducer,
state: nil,
middleware: [])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appRouter: AppRouter?
    var profile: Profile?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = Realm.Configuration(schemaVersion: 1)
        let realm = try! Realm(configuration: configuration)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        appRouter = AppRouter(window: window)
        loadContext()
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        let configuration = Realm.Configuration(schemaVersion: 1)
        let realm = try! Realm(configuration: configuration)
        saveContext()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func loadContext() {
        let realm = try! Realm()
        
        let state = realm.objects(DogListObject.self)
        let prof = realm.objects(ProfileObject.self)
        
        var permDogList = [Dog]()
        
        if let modelProfile = prof.first,
            let firstField = modelProfile.firstField,
            let secondField = modelProfile.secondField,
            let firstColor = modelProfile.firstColor,
            let secondColor = modelProfile.secondColor {
            
            let newProfile = Profile(firstField: firstField, secondField: secondField, firstColor: UIColor(hexString: firstColor), secondColor: UIColor(hexString: secondColor))
            profile = newProfile
        }
        
        if let modelObject = state.first {
            for dogModel in modelObject.dogModel {
                if let modelImage = dogModel.image.toImage() {
                    let modelName = dogModel.name
                    let modelWalking = dogModel.walking
                    print(modelName)
                    
                    guard let modelFirstTimer = dogModel.firstTimer else { return }
                    guard let modelSecondTimer = dogModel.secondTimer else { return }
                    let first = dogModel.firstSelect
                    let second = dogModel.secondSelect
                    let firstDate = dogModel.firstDate
                    let secondDate = dogModel.secondDate
                    
                    var permWalkArray = [Walk]()
                    for walk in dogModel.walkModel {
                        let time = walk.time
                        let dist = walk.distance
                        let first = walk.firstAction
                        let second = walk.secondAction
                        let newWalk = Walk(time: time, distance: dist, firstAction: first, secondAction: second)
                        permWalkArray.append(newWalk)
                    }
                    let modelWalkArray = permWalkArray
                    
                    permDogList.append(Dog(name: modelName, image: modelImage, firstTimer: modelFirstTimer, secondTimer: modelSecondTimer, walking: modelWalking, walkArray: modelWalkArray, firstSelect: first, secondSelect: second, firstDate: firstDate, secondDate: secondDate))
                    
                    print("-- After Load --")
                    print("Loaded Dog: ", modelName)
                }
            }
            let newState = State(dogState: DogState(dogs: permDogList, selectedDog: -1), navigationState: NavigationState(command: .goForward, route: .mydogs, history: [RoutingDestination]()), settingsState: initialSettingsState())
            store.dispatch(InitialDogState(state: newState))
        }
    }
    
    func saveContext() {
        
        let realm = try! Realm()

        try! realm.write {
            realm.deleteAll()
        }

        let profObject = ProfileObject()
        if let prof = profile {
            profObject.firstField = prof.firstField
            profObject.secondField = prof.secondField
            profObject.firstColor = prof.firstColor?.toHexString()
            profObject.secondColor = prof.secondColor?.toHexString()
            try! realm.write {
                realm.add(profObject)
                print("-- After Write --")
                print("Saved Profile: ", profObject)
            }
        }
        let dogListObj = DogListObject()
        for dog in store.state.dogState.dogs {
            let dogObj = DogObject()
            if let imgAsString = dog.image.toString() {
                dog.walkArray.forEach({ (Walk) in
                    let walkObj = WalkObject()
                    walkObj.time = Walk.time
                    walkObj.distance = Walk.distance
                    walkObj.firstAction = Walk.firstAction ?? false
                    walkObj.secondAction = Walk.secondAction ?? false
                    
                    dogObj.walkModel.append(walkObj)
                })
                
                dogObj.image = imgAsString
                dogObj.name = dog.name
                dogObj.firstTimer = dog.firstTimer
                dogObj.secondTimer = dog.secondTimer
                dogObj.walking = dog.walking
                dogObj.firstSelect = dog.firstSelect ?? false
                dogObj.secondSelect = dog.secondSelect ?? false
                dogObj.firstDate = dog.firstDate
                dogObj.secondDate = dog.secondDate
                
                try! realm.write {
                    dogListObj.dogModel.append(dogObj)
                    realm.add(dogListObj)
                    print("-- After Write --")
                    print("Full DogListObject: ", dogListObj)
                    print("DogListObject DogModel Count: ", dogListObj.dogModel.count)
                    print("Saved Dog: ", dogObj.name)
                }
            }
        }
    }
}


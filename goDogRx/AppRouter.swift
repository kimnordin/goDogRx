//
//  AppRouter.swift
//  FidesmoiOSApp
//
//  Created by Angel Anton on 08/11/2017.
//  Copyright © 2017 Fidesmo. All rights reserved.
//

import Foundation
import ReSwift

final class AppRouter {
    let navigationController: UINavigationController
    var tabBarController: UITabBarController?

    init(window: UIWindow) {
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        store.subscribe(self) { subscription in
            subscription.select { state in state.navigationState }
                .skipRepeats { old, new in
                    return old.route == new.route
                }
        }
    }

    fileprivate func presentModalViewController(identifier: String, animated _: Bool) {
        let viewController = instantiateViewController(identifier: identifier)
        navigationController.present(viewController, animated: true, completion: {})
    }

    fileprivate func pushViewController(identifier: String, animated: Bool) {
        let viewController = instantiateViewController(identifier: identifier)
        navigationController.pushViewController(viewController, animated: animated)
    }

    // This creates an inverted transition to the Pushed ViewController.
    fileprivate func popViewController(identifier: String, animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    fileprivate func instantiateViewController(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

    fileprivate func setupTabBarController() -> UITabBarController {
        let tbController = UITabBarController()
        tbController.tabBar.isHidden = true
        tbController.viewControllers = [
            instantiateViewController(identifier: "MyDogsController"),
            instantiateViewController(identifier: "NewDogController"),
            instantiateViewController(identifier: "DogController"),
            instantiateViewController(identifier: "ProfileController")
        ]
        return tbController
    }
}

// MARK: - StoreSubscriber

extension AppRouter: StoreSubscriber {
    func newState(state: NavigationState) {
        let shouldAnimate = navigationController.topViewController != nil
        print("new nav state")
        switch state.command {
        case .goForward:
            switch state.route {
            case .mydogs:
                print("go to mydogs")
                pushViewController(identifier: "MyDogsController", animated: true)
            case .newdog:
                print("go to newdog")
                pushViewController(identifier: "NewDogController", animated: true)
            case .dog:
                print("go to dog")
                pushViewController(identifier: "DogController", animated: true)
            case .profile:
                print("go to profile")
                pushViewController(identifier: "ProfileController", animated: true)
            }
        case .goBack:
            navigationController.popViewController(animated: true)
        }
    }
}

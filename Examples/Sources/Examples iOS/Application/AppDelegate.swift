//
//  AppDelegate.swift
//  Examples iOS
//
//  Created by panghu on 3/27/20.
//

import UIKit
import Watchants;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        return true
    }
}

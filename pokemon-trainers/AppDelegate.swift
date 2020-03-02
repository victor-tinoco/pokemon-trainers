//
//  AppDelegate.swift
//  pokemon-trainers
//
//  Created by Victor Martins Tinoco - VTN on 18/02/20.
//  Copyright © 2020 tinoco. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow()
        let navigation = UINavigationController(rootViewController: ListViewController.instantiate(viewModel: ListViewModel()))
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }
}


//
//  AppDelegate.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 21.09.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        if UserDefaults.standard.string(forKey: "AppleLanguage") == nil {
            UserDefaults.standard.setValue("uz-Cyrl", forKey: "AppleLanguage")
        }
        
        LocalizationSystem.shared.locale = Locale(identifier: UserDefaults.standard.string(forKey: "AppleLanguage") ?? Locale.current.identifier)
        
        return true
    }

}




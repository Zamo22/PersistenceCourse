//
//  AppDelegate.swift
//  Todoey
//
//  Created by Zaheer Moola on 2021/10/25.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            let realm = try Realm()
        } catch {
            print("Error initializing new realm \(error)")
        }

        return true
    }
}


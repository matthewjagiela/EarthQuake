//
//  AppDelegate.swift
//  uFail
//
//  Created by Matthew Jagiela on 12/26/19.
//  Copyright © 2019 Matthew Jagiela. All rights reserved.
//
import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

extension Date {
    /**
     Take the milliseconds from API and convert them to a date object.
     */
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func toString() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy hh:mm:ss a"
            return "\(dateFormatter.string(from: self)) UTC"
        
    }
}

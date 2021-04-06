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
            dateFormatter.dateFormat = "MM/dd/yy h:mm a"
            return "\(dateFormatter.string(from: self)) UTC"

    }
    
    func dateFrom(daysAway: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        return dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: (-1 * (daysAway - 1)), to: Date()) ?? Date())
    }
}

extension NSMutableAttributedString {
    var fontSize: CGFloat { return 14 }
    var boldFont: UIFont { return UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont: UIFont { return UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            .font: boldFont
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    func normal(_ value: String) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            .font: normalFont
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}

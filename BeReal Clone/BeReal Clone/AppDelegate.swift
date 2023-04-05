//
//  AppDelegate.swift
//  BeReal Clone
//
//  Created by Ruth Bilaro 3/18/23.

import UIKit

// TODO: Pt 1 - Import Parse Swift
import ParseSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        
        ParseSwift.initialize(applicationId: "0GsNisAN8hfNVN8rmFCQHt6O4vhJ7RA3EcRnYLxG",
                              clientKey: "dpEnAEVSXUbIqosDCJBTKP2OwKePnqbQYpyzNnK6",
                              serverURL: URL(string: "https://parseapi.back4app.com")!)


        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}



// Create your own value typed `ParseObject`.
struct GameScore: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    // All custom properties must be optional.
    var playerName: String?
    var points: Int?
}

// Sample Usage
//
// var score = GameScore()
// score.playerName = "Kingsley"
// score.points = 13


// OR Implement a custom initializer (OPTIONAL i.e. NOT REQUIRED)
// It's recommended to place custom initializers in an extension
// to preserve the memberwise initializer.
extension GameScore {

    // Use the init to set your custom properties
    // NOTE: Properties in custom init are NOT required to be optional
    init(playerName: String, points: Int) {
        self.playerName = playerName
        self.points = points
    }
}

// Sample Usage
//
// let score = GameScore(playerName: "Kingsley", points: 13)



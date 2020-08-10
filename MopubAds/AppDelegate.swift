//
//  AppDelegate.swift
//  MopubAds
//
//  Created by Sylvan Ash on 04/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit
import MoPub

enum AdType {
    case banner, rectangle, native

    var adUnitId: String {
        switch self {
            case .banner: return "8c6814b7e08345e2a39ee522a774b2e5"
            case .rectangle: return "d394eaf7019246778d7d03f991de16fd"
            case .native: return "865119d3b09c4875b6d81da8c7873d4b"
        }
    }

    var size: CGSize {
        switch self {
            case .banner: return CGSize(width: 320, height: 50)
            case .rectangle: return CGSize(width: 300, height: 250)
            case .native: return .zero
        }
    }

    var sizeString: String {
        switch self {
        case .banner: return "320x50"
        case .rectangle: return "300x250"
        case .native: return "0x0"
        }
    }

    var description: String {
        switch self {
            case .banner: return "320x50 banner ad"
            case .rectangle: return "300x250 medium rectangle ad"
            case .native: return "native ad"
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let adType: AdType = .native

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mopubConfig = MPMoPubConfiguration(adUnitIdForAppInitialization: AppDelegate.adType.adUnitId)
        mopubConfig.loggingLevel = .debug
        MoPub.sharedInstance().initializeSdk(with: mopubConfig) {
            print("💚 SDK initialization complete")
        }

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

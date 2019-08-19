//
//  AppDelegate.swift
//  HTTP Session
//
//  Created by Denis Bystruev on 15/08/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        URLCache.shared = URLCache(
            memoryCapacity: 10_000_000,
            diskCapacity: 20_000_000,
            diskPath: NSTemporaryDirectory()
        )
        
        return true
    }
}


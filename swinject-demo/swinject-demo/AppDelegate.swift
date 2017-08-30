//
//  AppDelegate.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/29/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import SwinjectStoryboard
import DemoModel
import DemoViewModel
import DemoView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let container = Container() { container in
        // Models
        container.register(Networking.self) { _ in Network() }
        container.register(IMarket.self) { r in Market(network: r.resolve(Networking.self)!) }
        
        // View models
        container.register(IMarketTableViewModel.self) { r
            in MarketTableViewModel(market: r.resolve(IMarket.self)!)
        }
        
        // Views
        container.storyboardInitCompleted(MarketTableViewController.self) { r, c in
            c.viewModel = r.resolve(IMarketTableViewModel.self)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        self.window = window
        
        let bundle = Bundle(for: MarketTableViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: self.container)
        window.rootViewController = storyboard.instantiateInitialViewController()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


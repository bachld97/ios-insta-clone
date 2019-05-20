//
//  AppDelegate.swift
//  Instagram Clone
//
//  Created by CPU12071 on 4/26/19.
//  Copyright © 2019 Le Duy Bach. All rights reserved.
//

import UIKit

func delay(_ delay: Double, closure: @escaping () -> ()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LoginScreenViewControler()
        window?.makeKeyAndVisible()
        return true
    }

}


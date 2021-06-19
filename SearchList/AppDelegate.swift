//
//  AppDelegate.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        KakaoSDKCommon.initSDK(appKey: KakaoKey.appKey)

        return true
    }


}


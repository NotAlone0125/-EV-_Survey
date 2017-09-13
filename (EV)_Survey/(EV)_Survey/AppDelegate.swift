//
//  AppDelegate.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/17.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var _mapManager = BMKMapManager.init()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        //百度地图
        let ret = _mapManager.start("rRimBDj34vQC5eHo07vr3EgXSMeF5SsV", generalDelegate: nil)
        if !ret {
            print("manager start failed!")
        }
        
        
        //视图控制器
        let ev_header = EV_Header.init()
        let tab:UITabBarController = ev_header.getTab()
        window?.rootViewController = tab

        Thread.sleep(forTimeInterval: 1.0)
        
        window?.makeKeyAndVisible()
        
        let array:[Any] = EV_FileManager.init().unArchiverReadRecords()
        if array.count > 0{
            let alertView = UIAlertController.init(title: "提示", message: "您还有\(array.count)条数据未上传,请前往上传", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "确定", style: .default, handler: { (alertAction:UIAlertAction) in
                
                let rootTab:UITabBarController = self.window?.rootViewController as! UITabBarController
                
                rootTab.selectedIndex = 1
            })
            alertView.addAction(action)
            window?.rootViewController?.present(alertView, animated: true, completion: nil)
        }
        
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


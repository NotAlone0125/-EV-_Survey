//
//  EV_Header.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/17.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class EV_Header: NSObject {
    
    let Shallow_Blue = UIColor.init(red: 30/255.0, green: 203/255.0, blue: 245/255.0, alpha: 1.0)

    let Base_gray = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
    
    
    let ScreenWidth = UIScreen.main.bounds.size.width
    let ScreenHeight = UIScreen.main.bounds.size.height
    let NavBarHeight = UINavigationController().navigationBar.frame.size.height
    
    func getTab() -> UITabBarController {
        let vcNav = UINavigationController.init(rootViewController: ViewController())
        let vcItem = UITabBarItem.init(title: "车辆信息", image: UIImage.init(named: "bike"), tag: 0)
        vcNav.tabBarItem = vcItem
        
        let uploadNav = UINavigationController.init(rootViewController: UploadViewController())
        let uploadItem = UITabBarItem.init(title: "上传", image: UIImage.init(named: "upload"), tag: 1)
        uploadNav.tabBarItem = uploadItem
        
        let tab = UITabBarController.init()
        tab.viewControllers = [vcNav,uploadNav]
        tab.tabBar.tintColor = EV_Header().Shallow_Blue
        
        return tab
    }
}

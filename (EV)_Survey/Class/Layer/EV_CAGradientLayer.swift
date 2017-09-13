//
//  EV_CAGradientLayer.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/18.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class EV_CAGradientLayer: NSObject {
    
    let ev_header = EV_Header.init()
    
    func gradientLayer(colors:Array<Any>,locations:Array<Any>) -> CAGradientLayer{
        let backLayer:CAGradientLayer = CAGradientLayer.init()
        backLayer.colors = colors
        backLayer.locations = locations as? [NSNumber]
        backLayer.startPoint=CGPoint.init(x: 0, y: 0)
        backLayer.endPoint=CGPoint.init(x: 1, y: 0)
        return backLayer
    }
    
}

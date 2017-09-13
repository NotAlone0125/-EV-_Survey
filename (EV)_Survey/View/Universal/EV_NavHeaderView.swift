//
//  EV_NavHeaderView.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/17.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class EV_NavHeaderView: UIView {

    var titleString:String?
    init(frame:CGRect,titleString:String) {
        self.titleString = titleString
        super.init(frame: frame)
        
        self.layoutSubviews()
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, titleString: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func layoutSubviews() {
        let ev_header = EV_Header.init()
        
        let backLayer:CAGradientLayer = EV_CAGradientLayer().gradientLayer(colors: [ev_header.Shallow_Blue.cgColor,ev_header.Shallow_Blue.cgColor], locations: [0.5,1.0])
        backLayer.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.addSublayer(backLayer)
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: (self.frame.size.width - 200)/2, y: 20, width: 200, height: self.frame.size.height - 20))
        titleLabel.text = titleString!
        titleLabel.font=UIFont.systemFont(ofSize: 18)
        titleLabel.textColor=UIColor.white
        titleLabel.textAlignment=NSTextAlignment(rawValue: 1)!
        self.addSubview(titleLabel)
    }
}

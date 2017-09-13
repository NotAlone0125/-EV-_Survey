//
//  EV_TextBackButton.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/18.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class EV_TextBackButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var backText:NSString?
    init(frame:CGRect,backText:NSString){
        self.backText = backText
        super.init(frame: frame)
        
        self.layoutSubviews()
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, backText: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        
        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        
        var size = backText?.boundingRect(with: CGSize.init(width: 320.0, height: 999.9), options: option, attributes: attributes, context: nil)
     
        if backText == nil {
            size = "返回".boundingRect(with: CGSize.init(width: 320.0, height: 999.9), options: option, attributes: attributes, context: nil)
        }
        
        let textLabel = UILabel.init()
        textLabel.center = CGPoint.init(x: self.center.x, y: self.frame.size.height/2)
        textLabel.bounds = CGRect.init(x: 0, y: 0, width: (size?.width)!, height: (size?.height)!)
        textLabel.text = backText! as String
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = NSTextAlignment.init(rawValue: 1)!
        textLabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(textLabel)
    
        let arrow = UIImageView.init(image: UIImage.init(named: "nav-icon-back"))
        //计算返回箭头的CenterX
        let arrowCenterX = self.center.x - (size?.width)!/2 - 4 - ((size?.height)!-10)/2
        print(arrowCenterX)
        arrow.center = CGPoint.init(x: arrowCenterX, y: self.frame.size.height/2)
        arrow.bounds = CGRect.init(x: 0, y: 0, width: (size?.height)! - 10, height: (size?.height)!)
        self.addSubview(arrow)
    }
}

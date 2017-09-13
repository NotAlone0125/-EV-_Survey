//
//  EV_AreaModel.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/22.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class EV_AreaModel: NSObject {
    var json:[String:Any] = [String:Any]()
    
    var id:String = String()
    var gov_code:String = String()
    var name:String = String()
    
    init(json:[String:Any]){
        self.json = json
        super.init()
        
        self.serializationJson()
    }
    
    func serializationJson() {
        
        print(json)
        
        id = json["_id"] as! String
        gov_code = String(describing: json["gov_code"])
        name = json["name"] as! String
    }
    
}

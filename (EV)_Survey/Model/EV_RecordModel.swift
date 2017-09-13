//
//  EV_RecordModel.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/22.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class EV_RecordModel: NSObject,NSCoding {
//    let body:[String:Any] = ["license":1,"unlicense":1,"geographic":["4.000","3.000"],"landmark":"商场","area":"599501b854b9ccf48dbac152","images":["theFirstImage09.png"],"env_watch":"物业看管","env_eletri":1]
//    EV_NetWorkRequest.postInfoWithBody(body: body) { (dic:Dictionary<String, Any>, isSucess:Bool) in
//    print("提交表单成功---\(dic)")
//    }
    
    override init() {
        super.init()

        self.serialization()
    }
    
    var license:Int = 0//上牌
    var unlicense:Int = 0//未上牌
    var geographic:[Double] = [Double]() //经纬度
    var landmark:String = String()//地标
    var area:String = String()//行政区域
    var images:[[Any]] = [[Any]]()//图片key值
    var env_watch:String = String()//看管情况
    var env_eletri:Int = 0//可否充电
    
    func serialization() {
        let userDefault = UserDefaults.standard
        
        license = (userDefault.object(forKey: "license") as? Int)!
        unlicense = (userDefault.object(forKey: "unlicense") as? Int)!
        geographic = (userDefault.object(forKey: "geographic") as? [Double])!
        landmark = (userDefault.object(forKey: "landmark") as? String)!
        area = (userDefault.object(forKey: "area") as? String)!
        images = (userDefault.object(forKey: "images") as? [[Any]])!
        env_watch = (userDefault.object(forKey: "env_watch") as? String)!
        env_eletri = (userDefault.object(forKey: "env_eletri") as? Int)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(NSNumber.init(integerLiteral: license), forKey: "license")
        aCoder.encode(NSNumber.init(integerLiteral: unlicense), forKey: "unlicense")
        aCoder.encode(geographic, forKey: "geographic")
        aCoder.encode(landmark, forKey: "landmark")
        aCoder.encode(area, forKey: "area")
        aCoder.encode(images, forKey: "images")
        aCoder.encode(env_watch, forKey: "env_watch")
        aCoder.encode(NSNumber.init(integerLiteral: env_eletri), forKey: "env_eletri")
    }
    
    required init?(coder aDecoder: NSCoder) {

        self.license = ((aDecoder.decodeObject(forKey: "license") as? NSNumber)?.intValue)!
        
        
        self.unlicense = ((aDecoder.decodeObject(forKey: "unlicense") as? NSNumber)?.intValue)!
        self.geographic = (aDecoder.decodeObject(forKey: "geographic") as? [Double])!
        self.landmark = (aDecoder.decodeObject(forKey: "landmark") as? String)!
        self.area = (aDecoder.decodeObject(forKey: "area") as? String)!
        self.images = (aDecoder.decodeObject(forKey: "images") as? [[Any]])!
        self.env_watch = (aDecoder.decodeObject(forKey: "env_watch") as? String)!
        self.env_eletri = ((aDecoder.decodeObject(forKey: "env_eletri") as? NSNumber)?.intValue)!
    }
}

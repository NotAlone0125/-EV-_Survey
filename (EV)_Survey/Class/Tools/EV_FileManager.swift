//
//  EV_FileManager.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/22.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class EV_FileManager: NSObject {
    
    //#pragma mark 获取文件路径
    func getFilePathWithDicComponent(dicComponent:String,fileComponent:String) -> String{
        let fm = FileManager.default
        
        //文件夹路径
        let dicrecoryPath = NSHomeDirectory().appending(dicComponent)
        if !fm.fileExists(atPath: dicrecoryPath) {
            try? fm.createDirectory(atPath: dicrecoryPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        //文件路径
        let filePath = NSHomeDirectory().appending(fileComponent)
        if !fm.fileExists(atPath: filePath) {
            fm.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        
        return filePath
    }
    
    //序列化
    func archiverWithArray(array:[Any],filepath:String){
        
        let data = NSMutableData.init(capacity: 0)
        
        let archiver:NSKeyedArchiver = NSKeyedArchiver.init(forWritingWith: data!)
        
        print(array)
        
        archiver.encode(array)
        
        archiver.finishEncoding()
        
        data?.write(toFile: filepath, atomically: true)
    }
    
    //反序列化
    func unArchiverWithFilepath(filePath:String) -> [Any]{
        let data = NSMutableData.init(contentsOfFile: filePath)
        
        if (data?.length)! <= 0 {//空的话创建数组
            let array = [Any]()
            self.archiverWithArray(array: array, filepath: filePath)
            return array
        }
        else{
            let unarchiver = NSKeyedUnarchiver.init(forReadingWith: data! as Data)
            
            let array = unarchiver.decodeObject()
            
            unarchiver.finishDecoding()
            
            return array as! [Any]
        }
    }
    
    
    //获取本地未上传的记录的文件地址
    func getRecordsFilePath() -> String{
        return self.getFilePathWithDicComponent(dicComponent: "/Documents/UploadRecord", fileComponent: "/Documents/UploadRecord/UploadList.plist")
    }
    
    //序列化的记录对象的编码
    func archiverReadRecordsWithArray(readRecordsArray:[Any]) {
        self.archiverWithArray(array: readRecordsArray, filepath: self.getRecordsFilePath())
    }
    
    //序列化的记录对象的解码
    func unArchiverReadRecords() -> [Any] {
        return self.unArchiverWithFilepath(filePath: self.getRecordsFilePath())
    }
    
    
    //获取图片路径
    func getImagePath(image:UIImage) -> (String?,String?) {
        
        var data:Data = Data.init()
        var preFix:String = String.init()
        
        if UIImagePNGRepresentation(image) == nil {
            data = UIImageJPEGRepresentation(image, 1.0)!
            preFix = ".jpg"
        }else{
            data = UIImagePNGRepresentation(image)!
            preFix = ".png"
        }
        
        ///图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let ImagePath = self.randomSmallCaseString(length: 32) + preFix
        let filePath = "\(rootPath)/\(ImagePath)"
        fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
        
        return (filePath,ImagePath)
    }
    
    //生成随机字符串作为图片名
    func randomSmallCaseString(length: Int) -> String {
        var output = ""
        for _ in 0..<length {
            let randomNumber = arc4random() % 26 + 97
            let randomChar = Character(UnicodeScalar(randomNumber)!)
            output.append(randomChar)
        }
        return output
    }
}

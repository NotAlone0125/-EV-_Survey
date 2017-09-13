//
//  PhotoViewController.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/24.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController,LPDQuoteImagesViewDelegate {

    let ev_header = EV_Header.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        self.layOutSubView()
    }

    var LPImagesView:LPDQuoteImagesView = LPDQuoteImagesView()
    
    func layOutSubView() {
        
        //导航栏高度和屏幕宽度
        let topHeight = ev_header.NavBarHeight + 20
        let screenWidth = ev_header.ScreenWidth
        
        //topView
        let navHeaderView = EV_NavHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: topHeight), titleString: "添加图片")
        self.view.addSubview(navHeaderView)
        
        //返回按钮
        let backButton = EV_TextBackButton.init(frame: CGRect.init(x: 0, y: 20, width: ev_header.NavBarHeight * 2, height: ev_header.NavBarHeight-2), backText: "返回")
        backButton.addTarget(self, action: #selector(InfoViewController.back), for: UIControlEvents.touchUpInside)
        self.view.addSubview(backButton)
        
        //保存按钮
        let saveButton = UIButton.init(frame: CGRect.init(x: ev_header.ScreenWidth - 60, y: 20, width: 60, height: ev_header.NavBarHeight))
        saveButton.setTitle("保存", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.addTarget(self, action: #selector(PhotoViewController.savePhoto), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
        //图片选择器
        LPImagesView = LPDQuoteImagesView.init(frame: CGRect.init(x: 0, y: topHeight, width: screenWidth, height: ev_header.ScreenHeight - topHeight), withCountPerRowInView: 4, cellMargin: 20)
        LPImagesView.navcDelegate = self
        LPImagesView.maxSelectedCount = 20
        self.view.addSubview(LPImagesView)
    }
    
    
    
    //保存图片
    var hud:MBProgressHUD?
    
    func savePhoto(){
        
        self.keyTokens.removeAll()
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let selectImageArray:[UIImage] = LPImagesView.selectedPhotos as! [UIImage]
        
        for image in selectImageArray {
            
            let file:(String?,String?) = EV_FileManager().getImagePath(image: image)
            
            self.uploadImageToQNFilePath(fileName: file.1!, filePath: file.0!)
        }
    }
    
    var keyTokens:[[Any]] = [[Any]]()
    
    func uploadImageToQNFilePath(fileName:String,filePath:String){
        
        //请求key
        EV_NetWorkRequest.getServiceKeyWithFileName(fileName: fileName) { (dic:Dictionary<String, Any>, isSucess:Bool) in
            
            let subDic:[String:Any] = dic["data"] as! Dictionary
            
            let keyTokenArray = [subDic["qiniu_key"],subDic["qiniu_token"],fileName,filePath]
            
            self.keyTokens.append(keyTokenArray)
            
            if self.keyTokens.count == self.LPImagesView.selectedPhotos.count {
                
                print(self.keyTokens)
                
                self.hud?.removeFromSuperview()
                
                print(self.keyTokens.count)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KeyTokens"), object: nil, userInfo: ["KeyTokens":self.keyTokens])
                
                self.back()
            }
        }
    }
    
    
    
    //POP
    func back() {
        self.navigationController?.popViewController(animated: true)
    }


}

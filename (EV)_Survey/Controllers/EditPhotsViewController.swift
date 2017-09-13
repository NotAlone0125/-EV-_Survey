//
//  EditPhotsViewController.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/25.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class EditPhotsViewController: UIViewController {

    let ev_header = EV_Header.init()

    var oldImageArray:[[Any]]?
    var indexSection:Int?
    
    
    init(oldImageArray:[[Any]]?,indexSection:Int?) {
        self.oldImageArray = oldImageArray
        self.indexSection = indexSection
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(){
        self.init(oldImageArray: nil,indexSection: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ev_header.Base_gray
        // Do any additional setup after loading the view.
        self.layOutSubView()
    }

    func layOutSubView() {
        
        self.layOutTopView()
        self.layOutViews()
    }
    
    //子视图
    var alreadyAdd = UILabel.init()
    var newAdd = UILabel.init()
    var oldImageScrollView = UIScrollView.init()
    var LPImagesView:LPDQuoteImagesView = LPDQuoteImagesView()
    
    func layOutViews() {
        //导航栏高度和屏幕宽度
        let topHeight = ev_header.NavBarHeight + 20
        let screenWidth = ev_header.ScreenWidth
        
        var font = UIFont()
        if #available(iOS 8.2, *) {
            font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        } else {
            font = UIFont.systemFont(ofSize: 14)
            // Fallback on earlier versions
        }
        
        //oldImageArray
        alreadyAdd = UILabel.init(frame: CGRect.init(x: 0, y: topHeight, width: screenWidth, height: 30))
        alreadyAdd.text = String.init(format: "   已添加(%d)", (oldImageArray?.count)!)
        alreadyAdd.font = font
        self.view.addSubview(alreadyAdd)
        
        let imageHeight = (screenWidth - 80) / 4
        
        oldImageScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: topHeight + 30, width: screenWidth, height: imageHeight + 20))
        oldImageScrollView.contentSize = CGSize.init(width: (20 + imageHeight) * CGFloat((self.oldImageArray?.count)!), height: 20 + imageHeight)
        oldImageScrollView.backgroundColor = UIColor.white
        self.view.addSubview(oldImageScrollView)
        
        for index in 0..<(self.oldImageArray?.count)!{
            let imageInfo:[Any] = oldImageArray![index]
            
            let imageView = UIImageView.init(frame: CGRect.init(x: 10 + (20 + imageHeight) * CGFloat(index), y: 10, width: imageHeight, height: imageHeight))
            imageView.image = UIImage.init(contentsOfFile: imageInfo[3] as! String)
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 4.0
            imageView.tag = 200 + index
            oldImageScrollView.addSubview(imageView)
            
            let width = (24 * screenWidth / 375) * 0.75
            
            let nookDeleteBtn = UIButton.init(frame: CGRect.init(x: imageHeight + imageView.frame.origin.x - 10, y: 10 - width/2, width: width, height: width))
            nookDeleteBtn.tag = 100 + index
            nookDeleteBtn.setImage(UIImage.init(named: "nookDeleteBtn"), for: .normal)
            nookDeleteBtn.addTarget(self, action: #selector(EditPhotsViewController.deleteOldImages(button:)), for: .touchUpInside)
            oldImageScrollView.addSubview(nookDeleteBtn)
        }
        
        //新添加的
        newAdd = UILabel.init(frame: CGRect.init(x: 0, y: topHeight + imageHeight + 20 + 30, width: screenWidth, height: 30))
        newAdd.text = "   新添加"
        newAdd.font = font
        self.view.addSubview(newAdd)
        
        
        //图片选择器
        let newAddY = newAdd.frame.origin.y
        
        LPImagesView = LPDQuoteImagesView.init(frame: CGRect.init(x: 0, y: newAddY + 30, width: screenWidth, height: ev_header.ScreenHeight - newAddY - 30), withCountPerRowInView: 4, cellMargin: 20)
        LPImagesView.backgroundColor = UIColor.white
        LPImagesView.navcDelegate = self
        LPImagesView.maxSelectedCount = 20
        self.view.addSubview(LPImagesView)
    }
    
    //导航栏视图
    func layOutTopView(){
        //导航栏高度和屏幕宽度
        let topHeight = ev_header.NavBarHeight + 20
        let screenWidth = ev_header.ScreenWidth
        
        //topView
        let navHeaderView = EV_NavHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: topHeight), titleString: "编辑图片")
        self.view.addSubview(navHeaderView)
        
        //返回按钮
        let backButton = EV_TextBackButton.init(frame: CGRect.init(x: 0, y: 20, width: ev_header.NavBarHeight * 2, height: ev_header.NavBarHeight-2), backText: "返回")
        backButton.addTarget(self, action: #selector(EditPhotsViewController.back), for: UIControlEvents.touchUpInside)
        self.view.addSubview(backButton)
        
        
        //保存按钮
        let uploadButton = UIButton.init(frame: CGRect.init(x: ev_header.ScreenWidth - 60, y: 20, width: 60, height: ev_header.NavBarHeight))
        uploadButton.setTitle("保存", for: .normal)
        uploadButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        uploadButton.addTarget(self, action: #selector(EditPhotsViewController.saveButton), for: .touchUpInside)
        self.view.addSubview(uploadButton)
    }
    
    //删除之前的照片
    func deleteOldImages(button:UIButton){
        //索引
        let index = button.tag - 100
        
        print(index)
        
        //删除视图
        let imageView:UIImageView = oldImageScrollView.viewWithTag(200 + index) as! UIImageView
        button.removeFromSuperview()
        imageView.removeFromSuperview()
        
        //重新赋值tag
        
        let offset = (ev_header.ScreenWidth - 80) / 4 + 20
        
        for  subView in oldImageScrollView.subviews{
            
            if (subView.tag >= 100) && (subView.tag < 200){//按钮
                if (subView.tag - 100) > index {
                    subView.tag -= 1
                    UIView.animate(withDuration: 0.1, animations: {
                        subView.frame = CGRect.init(x: subView.frame.origin.x - offset, y: subView.frame.origin.y, width: subView.frame.size.width, height: subView.frame.size.height)
                    })
                }
            }else{//imageView
                if (subView.tag - 200) > index {
                    subView.tag -= 1
                    UIView.animate(withDuration: 0.1, animations: {
                        subView.frame = CGRect.init(x: subView.frame.origin.x - offset, y: subView.frame.origin.y, width: subView.frame.size.width, height: subView.frame.size.height)
                    })
                }
            }
        }
        
        //删除数组数据
        oldImageArray?.remove(at: index)
        
        //重新赋值contentSize
        oldImageScrollView.contentSize = CGSize.init(width: offset * CGFloat((self.oldImageArray?.count)!), height: offset)
        
        //更改文字显示
        alreadyAdd.text = String.init(format: "   已添加(%d)", (oldImageArray?.count)!)
        
        //老数组清空以后移除控件
        if (oldImageArray?.count)! <= 0 {
            UIView.animate(withDuration: 0.3, animations: { 
                self.alreadyAdd.removeFromSuperview()
                self.oldImageScrollView.removeFromSuperview()
                self.newAdd.removeFromSuperview()
                self.LPImagesView.frame = CGRect.init(x: 0, y: self.ev_header.NavBarHeight + 20, width: self.ev_header.ScreenWidth, height: self.ev_header.ScreenHeight - (self.ev_header.NavBarHeight + 20))
            })
        }
    }
    
    
    //保存最新的照片数据
    var hud:MBProgressHUD?
    func saveButton() {
        
        if LPImagesView.selectedPhotos.count > 0{
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let selectImageArray:[UIImage] = LPImagesView.selectedPhotos as! [UIImage]
            for image in selectImageArray {
                
                let file:(String?,String?) = EV_FileManager().getImagePath(image: image)
                
                self.uploadImageToQNFilePath(fileName: file.1!, filePath: file.0!)
            }
        }else{
            if (self.oldImageArray?.count)! <= 0 {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud?.mode = MBProgressHUDModeText
                hud?.labelText = "没有图片"
                hud?.margin = 10.0
                hud?.hide(true, afterDelay: 0.5)
            }else{
                self.replaceData()
                self.back()
            }
        }
        
    }

    var newkeyTokens:[[Any]] = [[Any]]()
    
    func uploadImageToQNFilePath(fileName:String,filePath:String){
        
        //请求key
        EV_NetWorkRequest.getServiceKeyWithFileName(fileName: fileName) { (dic:Dictionary<String, Any>, isSucess:Bool) in
            
            let subDic:[String:Any] = dic["data"] as! Dictionary
            
            let keyTokenArray = [subDic["qiniu_key"],subDic["qiniu_token"],fileName,filePath]
            
            self.newkeyTokens.append(keyTokenArray)
            
            if self.newkeyTokens.count == self.LPImagesView.selectedPhotos.count {
 
                self.hud?.removeFromSuperview()
                
                self.replaceData()
            
                self.back()
            }
        }
    }
    
    func replaceData() {
        
        if (self.oldImageArray?.count)! > 0 {
            for old in self.oldImageArray!{
                self.newkeyTokens.append(old)
            }
        }
        
        print(self.newkeyTokens)
        
        //替换本地数据
        let fileManager:EV_FileManager = EV_FileManager.init()
        var array:[Any] = fileManager.unArchiverReadRecords()
        
        let model:EV_RecordModel = array[self.indexSection!] as! EV_RecordModel
        model.images = self.newkeyTokens
        array[self.indexSection!] = model
        
        fileManager.archiverReadRecordsWithArray(readRecordsArray: array)
    }

    
    //POP
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

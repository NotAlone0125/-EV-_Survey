//
//  InfoViewController.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/18.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LPDQuoteImagesViewDelegate {

    let ev_header = EV_Header.init()

    //区域列表
    var areaList:[[String:Any]] = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white

        
        //图片选择器传回的数据
        NotificationCenter.default.addObserver(self, selector: #selector(InfoViewController.receiveKeyTokens(not:)), name: NSNotification.Name(rawValue: "KeyTokens"), object: nil)
        
        self.layOutSubView()        
    }
    
    var keyTokens:[[Any]] = [[Any]]()
    
    func receiveKeyTokens(not:Notification) {
        
        self.keyTokens = not.userInfo?["KeyTokens"] as! [[Any]]

        let selectPicButton:UIButton = self.view.viewWithTag(104) as! UIButton
        selectPicButton.setTitle("\(String(describing: self.keyTokens.count))张", for: .normal)
        self.fieldArray[4] = [0:self.keyTokens]
    }
    
    func layOutSubView() {
        
        //导航栏高度和屏幕宽度
        let topHeight = ev_header.NavBarHeight + 20
        let screenWidth = ev_header.ScreenWidth
        
        //topView
        let navHeaderView = EV_NavHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: topHeight), titleString: "周边信息")
        self.view.addSubview(navHeaderView)
        
        //返回按钮
        let backButton = EV_TextBackButton.init(frame: CGRect.init(x: 0, y: 20, width: ev_header.NavBarHeight * 2, height: ev_header.NavBarHeight-2), backText: "返回")
        backButton.addTarget(self, action: #selector(InfoViewController.back), for: UIControlEvents.touchUpInside)
        self.view.addSubview(backButton)
        
        
        //创建选项
        self.createAlertView()
    }
    
    //创建视图
    func createAlertView() {
        //周边环境
        
        let eachHeight = (ev_header.ScreenHeight - ev_header.NavBarHeight - 20 - 70) / 5
        let titleArray = ["周边地标","行政区域","周边环境备注","是否可充电","照片"]
        
        for index in 0...4{
            //标题
            let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: ev_header.NavBarHeight + 20 + eachHeight * CGFloat(index), width: ev_header.ScreenWidth, height: eachHeight / 2))
            titleLabel.text = titleArray[index]
            if #available(iOS 8.2, *) {
                titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
            } else {
                titleLabel.font = UIFont.systemFont(ofSize: 16)
            }
            titleLabel.textAlignment = NSTextAlignment.init(rawValue: 1)!
            self.view.addSubview(titleLabel)
            
            //文本按钮
            let textButton = UIButton.init(frame: CGRect.init(x: 20, y: eachHeight / 2 + ev_header.NavBarHeight + 20 + eachHeight * CGFloat(index) , width: ev_header.ScreenWidth - 40, height: eachHeight / 2))
            textButton.backgroundColor = ev_header.Shallow_Blue
            textButton.layer.masksToBounds = true
            textButton.layer.cornerRadius = 5.0
            textButton.setTitle("请选择", for: UIControlState.normal)
            textButton.tag = 100 + index
            textButton.addTarget(self, action: #selector(buttonClick(button:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(textButton)
        }
        
        //下一步操作
        let nextButton = UIButton.init(frame: CGRect.init(x: 0, y: ev_header.ScreenHeight - 50, width: ev_header.ScreenWidth, height: 50))
        nextButton.setTitle("信息填写完毕，下一步", for: UIControlState.normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: UIControlEvents.touchUpInside)
        self.view.addSubview(nextButton)
        
        
        let backLayer:CAGradientLayer = EV_CAGradientLayer().gradientLayer(colors: [ev_header.Shallow_Blue.cgColor,ev_header.Shallow_Blue.cgColor], locations: [0.5,1.0])
        backLayer.frame = CGRect.init(x: 0, y: 0, width: nextButton.frame.size.width, height: nextButton.frame.size.height)
        nextButton.layer.addSublayer(backLayer)
        
        
        //请求行政区域列表
        EV_NetWorkRequest.getAreaList { (dic:Dictionary<String, Any>, isSucess:Bool) in
            if isSucess{
                //print("行政区域列表--\(dic)")
                let subDic:[String:Any] = dic["data"] as! Dictionary
                if subDic.keys.count > 0{
                    self.areaList = (subDic["arealist"] as? [[String:Any]])!
                }
            }
        }
    }
    
    func nextStep() {
 
        var count = 0
        
        for field in fieldArray {
            if field.keys.contains(-1) {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud?.mode = MBProgressHUDModeText
                hud?.labelText = "信息未完善"
                hud?.margin = 10.0
                hud?.hide(true, afterDelay: 0.5)
                return
            }
            count += 1
        }
        
        if count == 5{
            //先存储数据
            

            var valuesArray:[Any] = [Any]()
            var keysArray:[Any] = [Any]()
            for i in 0...4{
                for value in fieldArray[i].values {
                    valuesArray.append(value!)
                }
                for key in fieldArray[i].keys {
                    keysArray.append(key)
                }
            }
            let userDefault = UserDefaults.standard
            
            userDefault.set(valuesArray[0], forKey: "landmark")
            
            let areaIndex:Int = keysArray[1] as! Int
            let model = modelArray[areaIndex]
            userDefault.set(model.id + "+" + model.name, forKey: "area")
            
            userDefault.set(valuesArray[2], forKey: "env_watch")
            
            let eletriIndex:Int = keysArray[3] as! Int
            userDefault.set(NSNumber.init(integerLiteral: eletriIndex), forKey: "env_eletri")

            print(valuesArray[4])
            userDefault.set(valuesArray[4], forKey: "images")

            userDefault.synchronize()
            
            print(userDefault.dictionaryRepresentation())
            
            let mapVC = MapViewController()
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        
    }
    //按钮处理时间（弹窗和图片选择器）
    func buttonClick(button:UIButton) {
        if button.tag - 100 < 4 {//除去最后一个按钮
           self.presentAlert(button: button)
        }else{
            self.selectImages()
        }
    }
    
    //Present Alert
    
    var fieldArray:[[Int:Any?]] = [[-1:nil],[-1:nil],[-1:nil],[-1:nil],[-1:nil]]
    
    var modelArray:[EV_AreaModel] = [EV_AreaModel]()
    
    var areaNameArray:[String] = [String]()
    
    
    func presentAlert(button:UIButton){
        
        let index = button.tag - 100
        
        //ALERT显示的文字
        modelArray.removeAll()
        areaNameArray.removeAll()

        if areaList.count > 0 {
            for i in 0..<areaList.count{
                let model = EV_AreaModel.init(json: areaList[i])
                modelArray.append(model)
                print(model.name)
                areaNameArray.append(model.name)
            }
        }
 
        let selectArray = [["地铁口","商场","写字楼","农副市场","美食城","超市","医院","天桥","商场+地铁口","其他"],areaNameArray,["周围有小商户","物业统一管理","有物业","周围有人看管","其他"],["不可供电","可供电"]]
        
        let alertView = UIAlertController.init(title: "请选择", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        for i in 0..<selectArray[index].count {
            
            let title:String = selectArray[index][i] 
            
            
            let action = UIAlertAction.init(title: title, style: UIAlertActionStyle.default, handler: { (alertAction:UIAlertAction) in
                if title == "其他"{
                    //显示输入框ALERT
                    let otherAlertView = UIAlertController.init(title: "其他", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    otherAlertView.addTextField(configurationHandler: { (textField: UITextField!) in
                        textField.placeholder = "请输入"
                    })
                    
                    otherAlertView.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: { (otherAlertAction:UIAlertAction) in
                        
                        let title = (otherAlertView.textFields?[0].text == "") ? "请选择" : otherAlertView.textFields?[0].text
                        
                        button.setTitle(title, for: UIControlState.normal)
                        self.fieldArray[button.tag - 100] = [i:title]
                    }))
                    
                    self.present(otherAlertView, animated: true, completion: {
                        
                    })
                    
                }
                else{
                    button.setTitle(title, for: UIControlState.normal)
                    self.fieldArray[button.tag - 100] = [i:title]
                }
            })
            alertView.addAction(action)
        }
        
        //添加Action
        let action = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
        })
        alertView.addAction(action)
        
        self.present(alertView, animated: true, completion:nil)
    }
    
    //选择图片
    
    var pickImage = UIImage.init()
    
    let photoVC = PhotoViewController.init()
    
    func selectImages(){

        self.navigationController?.pushViewController(photoVC, animated: true)
        
//        let alertView = UIAlertController.init(title: "请选择", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
//        
//        alertView.addAction(UIAlertAction.init(title: "从相册获取", style: UIAlertActionStyle.default, handler: { (alertAction:UIAlertAction) in
//            self.gotoImageLibrary(type: .photoLibrary)
//        }))
//
//        alertView.addAction(UIAlertAction.init(title: "从相机获取", style: UIAlertActionStyle.default, handler: { (alertAction:UIAlertAction) in
//            self.gotoImageLibrary(type: .camera)
//        }))
//        
//        alertView.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (alertAction:UIAlertAction) in
//            
//        }))
//        
//        self.present(alertView, animated: true, completion: nil)
    }
    
//    //从相册读取照片
//    func gotoImageLibrary(type:UIImagePickerControllerSourceType){
//        if UIImagePickerController.isSourceTypeAvailable(type) {
//            
//            let picker = UIImagePickerController.init()
//            picker.delegate = self
//            picker.sourceType = type
//            self.present(picker, animated: true, completion: {
//                self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            })
//        }
//        else{
//            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            hud?.mode = MBProgressHUDModeText
//            hud?.labelText = "访问图片库错误"
//            hud?.margin = 10.0
//            hud?.hide(true, afterDelay: 0.5)
//        }
//    }
//    
//    var hud:MBProgressHUD?
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.hud?.removeFromSuperview()
//        picker.dismiss(animated: true) {
//            
//        }
//    }
//    
//    //UIImagePickerControllerDelegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        /*
//         key:UIImagePickerControllerMediaType
//             UIImagePickerControllerReferenceURL
//             UIImagePickerControllerOriginalImage
//        */
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            pickImage = image
//            print("PickImage \(pickImage)")
//            
//        } else{
//            self.hud?.removeFromSuperview()
//            print("Something went wrong")
//        }
//        picker.dismiss(animated: true) {
//            
//            let file:(String?,String?) = self.getImagePath(image: self.pickImage)
//            
//            self.uploadImageToQNFilePath(fileName: file.1!, filePath: file.0!)
//        }
//    }
//    
//    //开始上传图片，获取路径和服务器token
//
//    var keyTokens:[[Any]] = [[Any]]()
//    
//    
//    func uploadImageToQNFilePath(fileName:String,filePath:String){
//        
//        //请求key
//        EV_NetWorkRequest.getServiceKeyWithFileName(fileName: fileName) { (dic:Dictionary<String, Any>, isSucess:Bool) in
//    
//            let subDic:[String:Any] = dic["data"] as! Dictionary
//            
//            let keyTokenArray = [subDic["qiniu_key"],subDic["qiniu_token"],fileName,filePath]
//            
//            self.keyTokens.append(keyTokenArray)
//            
//            let selectPicButton:UIButton = self.view.viewWithTag(104) as! UIButton
//            selectPicButton.setTitle("\(String(describing: self.keyTokens.count))张", for: .normal)
//            self.fieldArray[4] = [0:self.keyTokens]
//
//            self.hud?.removeFromSuperview()
//        }
//    }
//    
//    //获取图片路径
//    func getImagePath(image:UIImage) -> (String?,String?) {
//        
//        var data:Data = Data.init()
//        var preFix:String = String.init()
//        
//        if UIImagePNGRepresentation(image) == nil {
//            data = UIImageJPEGRepresentation(image, 1.0)!
//            preFix = ".jpg"
//        }else{
//            data = UIImagePNGRepresentation(image)!
//            preFix = ".png"
//        }
//        
//        ///图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        let fileManager = FileManager.default
//        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let ImagePath = self.randomSmallCaseString(length: 32) + preFix
//        let filePath = "\(rootPath)/\(ImagePath)"
//        fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
//        
//        return (filePath,ImagePath)
//    }
//    
//    //生成随机字符串作为图片名
//    func randomSmallCaseString(length: Int) -> String {
//        var output = ""
//        for _ in 0..<length {
//            let randomNumber = arc4random() % 26 + 97
//            let randomChar = Character(UnicodeScalar(randomNumber)!)
//            output.append(randomChar)
//        }
//        return output
//    }
    
    //POP
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

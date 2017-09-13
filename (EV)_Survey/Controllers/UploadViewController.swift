//
//  UploadViewController.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/22.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let ev_header = EV_Header.init()
    
    var dataSource:[EV_RecordModel] = [EV_RecordModel]()
    
    var alreadyUpLoadIndex = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        dataSource = EV_FileManager.init().unArchiverReadRecords() as! [EV_RecordModel]
        tableView?.reloadData() 
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.layOutSubView()
    }
    
    var tableView:UITableView?
    
    func layOutSubView() {
        
        //导航栏高度和屏幕宽度
        let topHeight = ev_header.NavBarHeight + 20
        let screenWidth = ev_header.ScreenWidth
        
        //topView
        let navHeaderView = EV_NavHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: topHeight), titleString: "传输列表")
        self.view.addSubview(navHeaderView)
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: topHeight, width: ev_header.ScreenWidth, height: ev_header.ScreenHeight - topHeight - 49), style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        self.view.addSubview(tableView!)
        
        //上传按钮
        let uploadButton = UIButton.init(frame: CGRect.init(x: ev_header.ScreenWidth - 60, y: 20, width: 60, height: ev_header.NavBarHeight))
        uploadButton.setTitle("上传", for: .normal)
        uploadButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        uploadButton.addTarget(self, action: #selector(UploadViewController.upLoadData), for: .touchUpInside)
        self.view.addSubview(uploadButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indentifier:String = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)
        if !(cell != nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: indentifier)
        }
        
        if ((cell?.viewWithTag(500)) != nil){
            cell?.viewWithTag(500)?.removeFromSuperview()
        }
        
        cell?.addSubview(self.createCellView(indexPath: indexPath))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .default, title: "删除") { (action:UITableViewRowAction, indexPath:IndexPath) in
            
            //清除本地数据
            let fileManager:EV_FileManager = EV_FileManager.init()
            var array:[Any] = fileManager.unArchiverReadRecords()
            
            array.remove(at: indexPath.section)
            
            fileManager.archiverReadRecordsWithArray(readRecordsArray: array)
            
            //清除tableView中该行数据
            self.dataSource.remove(at: indexPath.section)
            self.tableView?.reloadData()
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model:EV_RecordModel = dataSource[indexPath.section]
        
        let editPhotoVC:EditPhotsViewController = EditPhotsViewController.init(oldImageArray: model.images, indexSection: indexPath.section)
        editPhotoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editPhotoVC, animated: true)
    }
    
    func createCellView(indexPath:IndexPath) -> UIView {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ev_header.ScreenWidth, height: 180))
        view.tag = 500
        
        let model:EV_RecordModel = dataSource[indexPath.section]
        
        //上牌和未上牌，经度和纬度，行政区域和充电
        
        let eletriString = (model.env_eletri == 0) ? "不可供电":"可供电"

        //print(model.area.components(separatedBy: "+"))
        
        
        
        let textArray = ["上牌数量 : \(model.license)",
                         "未上牌数量 : \(model.unlicense)",
                         String.init(format: "经度 : %.6f", model.geographic[0]),
                         String.init(format: "纬度 : %.6f", model.geographic[0]),
                         "行政区域 : \(model.area.components(separatedBy: "+")[1])",
                         "是否可充电 : \(eletriString)",
                         "周边地标 : \(model.landmark)",
                         "周边环境 : \(model.env_watch)",
                         "图片 : \(model.images.count)张"]
         var font = UIFont()
        if #available(iOS 8.2, *) {
            font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        } else {
            font = UIFont.systemFont(ofSize: 14)
            // Fallback on earlier versions
        }
        
        let labelWidth = (ev_header.ScreenWidth - 20)/2
        
        
        for i in 0...5{
            let textlabel = UILabel.init(frame: CGRect.init(x:10 + labelWidth * CGFloat(i%2), y: 30 * CGFloat(i/2), width: labelWidth, height: 30))
            textlabel.text = textArray[i]
            textlabel.font = font
            view.addSubview(textlabel)
        }
        
        //周边地标，周边环境，图片
        for i in 6...8{
            let textlabel = UILabel.init(frame: CGRect.init(x: 10, y: 90 + (i - 6) * 30, width: Int(labelWidth * 2), height: 30))
            textlabel.text = textArray[i]
            textlabel.font = font
            view.addSubview(textlabel)
        }
        
        return view
    }

    var hud:MBProgressHUD?
    
    
    func upLoadData() {
        if self.dataSource.count > 0 {
            let dataArrayCopy:[EV_RecordModel] = dataSource
            
            //每次点击上传充值
            alreadyUpLoadIndex = 0
            
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            for model in dataArrayCopy{
                
                //存储服务器返回的key值
                var imageKeys = [String]()
                
                //遍历本地存储的keys
                for keyInfo in model.images{
                    
                    //七牛云
                    let upManager = QNUploadManager.init()
                    let uploadOption = QNUploadOption.init(mime: nil, progressHandler: { (key:String?, percent:Float) in
                        print("percent===\(percent)")
                    }, params: nil, checkCrc: false, cancellationSignal: nil)
                    
                    //上传图片文件
                    if FileManager.default.fileExists(atPath: keyInfo[3] as! String) == true {
                        upManager?.putFile(keyInfo[3] as! String, key: keyInfo[0] as! String, token: keyInfo[1] as! String, complete: { (info:QNResponseInfo?, key:String?, resp:[AnyHashable : Any]?) in
                            
                            print(info!.error)
                            if info?.error == nil{//上传成功
                                imageKeys.append(key!)
                                if imageKeys.count == model.images.count{
                                    
                                    //最后一张上传完毕，提交表单
                                    self.commitData(model: model, imageKeys: imageKeys ,modelCount: dataArrayCopy.count)
                                }
                            }
                            
                        }, option: uploadOption)
                    }
                }
            }
        }
    }
    
    
    
    func commitData(model:EV_RecordModel,imageKeys:[String],modelCount:Int) {
        
        alreadyUpLoadIndex += 1
        
        let body:[String:Any]
            = ["license":model.license,
               "unlicense":model.unlicense,
               "geographic":model.geographic,
               "landmark":model.landmark,
               "area":model.area.components(separatedBy: "+")[0],"images":imageKeys,
               "env_watch":model.env_watch,
               "env_eletri":model.env_eletri]
        EV_NetWorkRequest.postInfoWithBody(body: body) { (dic:Dictionary<String, Any>, isSucess:Bool) in
            print("提交表单成功---\(dic)")
            
            
            //清除tableView中该行数据
            self.dataSource.removeFirst()
            self.tableView?.reloadData()
            
            //清除本地数据
            let fileManager:EV_FileManager = EV_FileManager.init()
            var array:[Any] = fileManager.unArchiverReadRecords()
            
            array.removeFirst()
            
            fileManager.archiverReadRecordsWithArray(readRecordsArray: array)
            
            if self.alreadyUpLoadIndex == modelCount {
                self.hud?.removeFromSuperview()
            }
        }
    }
}

//
//  MapViewController.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/19.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit


class MapViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate{

    let ev_header = EV_Header.init()
    
    override func viewWillAppear(_ animated: Bool) {
        mapView?.viewWillAppear()
        mapView?.delegate = self
        locService?.delegate = self
        geocodesearch?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView?.viewWillDisappear()
        mapView?.delegate = nil
        locService?.delegate = nil
        geocodesearch?.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.layOutSubView()
    }
    
    func layOutSubView() {
        
        //导航栏高度和屏幕宽度
        let topHeight = ev_header.NavBarHeight + 20
        let screenWidth = ev_header.ScreenWidth
        
        //topView
        let navHeaderView = EV_NavHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: topHeight), titleString: "地理位置")
        self.view.addSubview(navHeaderView)
        
        //返回按钮
        let backButton = EV_TextBackButton.init(frame: CGRect.init(x: 0, y: 20, width: ev_header.NavBarHeight * 2, height: ev_header.NavBarHeight-2), backText: "返回")
        backButton.addTarget(self, action: #selector(MapViewController.back), for: UIControlEvents.touchUpInside)
        self.view.addSubview(backButton)
        
        //保存按钮
        let saveButton = UIButton.init(frame: CGRect.init(x: ev_header.ScreenWidth - 60, y: 20, width: 60, height: ev_header.NavBarHeight))
        saveButton.setTitle("保存", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.addTarget(self, action: #selector(MapViewController.saveData), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
        self.mapViewLayOut()
        
        self.startLoaction()
    }

    //地图视图布局
    var locService:BMKLocationService?
    var mapView:BMKMapView?
    var geocodesearch:BMKGeoCodeSearch?
    
    var tableView:UITableView?
    var currentLocationBtn:UIButton?
    var dataSourse:[BMKPoiInfo] = [BMKPoiInfo]()
    
    lazy var centerCallOutImageView = UIImageView.init(image: UIImage.init(named: "location_green_icon"))
    
    func mapViewLayOut(){
        let contentHeight = (ev_header.ScreenHeight - (ev_header.NavBarHeight + 20)) / 2
        
        mapView = BMKMapView.init(frame: CGRect.init(x: 0, y: ev_header.NavBarHeight + 20, width: ev_header.ScreenWidth, height: contentHeight))
        mapView?.isZoomEnabled = false
        mapView?.isZoomEnabledWithTap = false
        mapView?.zoomLevel = 17
        self.view.addSubview(mapView!)
        
        locService = BMKLocationService.init()
        geocodesearch = BMKGeoCodeSearch.init()
        
        centerCallOutImageView.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        centerCallOutImageView.center = CGPoint.init(x: (mapView?.center.x)!, y: (mapView?.center.y)!)
        self.view.addSubview(centerCallOutImageView)
        self.view.bringSubview(toFront: centerCallOutImageView)
        
        mapView?.layoutIfNeeded()
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y:  ev_header.NavBarHeight + 20 + contentHeight, width: ev_header.ScreenWidth, height: contentHeight), style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        currentLocationBtn = UIButton.init(frame: CGRect.init(x: 10, y: (tableView?.frame.origin.y)! - 60, width: 50, height: 50))
        currentLocationBtn?.setImage(UIImage.init(named: "location_back_icon"), for: UIControlState.normal)
        currentLocationBtn?.setImage(UIImage.init(named: "location_blue_icon"), for: UIControlState.selected)
        currentLocationBtn?.addTarget(self, action: #selector(MapViewController.startLoaction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(currentLocationBtn!)
        self.view.bringSubview(toFront: currentLocationBtn!)
    }
    
    
    //开始定位
    var isFirstLocation:Bool?
    var currentSelectLocationIndex:Int?
    var currentCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D() {
        didSet{
            self.startGeocodesearchWithCoordinate(coordinate: currentCoordinate)
        }
    }
    
    func startLoaction(){
        isFirstLocation = true
        currentSelectLocationIndex = 0
        self.currentLocationBtn?.isSelected = true
        locService?.startUserLocationService()

        mapView?.showsUserLocation = false;//先关闭显示的定位图层
        mapView?.userTrackingMode = BMKUserTrackingModeFollow//设置定位的状态
        mapView?.showsUserLocation = true//显示定位图层
    }
    
    func startGeocodesearchWithCoordinate(coordinate:CLLocationCoordinate2D){
        
        let reverseGeocodeSearchOption = BMKReverseGeoCodeOption.init()
        reverseGeocodeSearchOption.reverseGeoPoint = coordinate
        let flag = geocodesearch?.reverseGeoCode(reverseGeocodeSearchOption)
        if flag! {
            print("反geo检索发送成功")
        }else{
            print("反geo检索发送失败")
        }
    }

    //TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indentifier:String = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)
        if !(cell != nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: indentifier)
        }
        
        if dataSourse.count > 0{
            let model:BMKPoiInfo = dataSourse[indexPath.row]
            
            
            cell?.textLabel?.text = model.name
            cell?.detailTextLabel?.text = model.address
            cell?.detailTextLabel?.textColor = UIColor.gray
            
            if currentSelectLocationIndex == indexPath.row{
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            }else{
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model:BMKPoiInfo = dataSourse[indexPath.row]
        let mapStatus:BMKMapStatus = (mapView?.getMapStatus())!
        mapStatus.targetGeoPt = model.pt
        mapView?.setMapStatus(mapStatus, withAnimation: true)
        currentSelectLocationIndex = indexPath.row
        tableView.reloadData()
    }
    
    //BMKMapViewDelegate
    
    /**
     *在地图View将要启动定位时，会调用此函数
     *@param mapView 地图View
     */
    func willStartLocatingUser() {
        print("start locate")
    }
    
    /**
     *用户方向更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        mapView?.updateLocationData(userLocation)
    }
    
    /**
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdate(_ userLocation: BMKUserLocation!) {
        isFirstLocation = false
        currentLocationBtn?.isSelected = false
        mapView?.updateLocationData(userLocation)
        currentCoordinate = userLocation.location.coordinate
        
        if currentCoordinate.latitude != 0 {
            locService?.stopUserLocationService()
        }
    }
    
    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
        print("stop locate")
    }
    
    /**
     *定位失败后，会调用此函数
     *@param mapView 地图View
     *@param error 错误号，参考CLError.h中定义的错误号
     */
    func didFailToLocateUserWithError(_ error: Error!) {
        print("location error")
    }
    
    func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        print("map view: click blank")
    }
    
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        if isFirstLocation == false {
            let tt = mapView.convert(centerCallOutImageView.center, toCoordinateFrom: centerCallOutImageView)
            currentCoordinate = tt
        }
    }
    
    //BMKGeoCodeSearchDelegate
    /**
     *返回地址信息搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结BMKGeoCodeSearch果
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        print("返回地址信息搜索结果,失败-------------")
    }
    
    /**
     *返回反地理编码搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            dataSourse.removeAll()
            dataSourse = result.poiList as! [BMKPoiInfo]
            
            if isFirstLocation == true {
                let first = BMKPoiInfo.init()
                first.address = result.address
                first.name = "[当前位置]"
                first.pt = result.location
                first.city = result.addressDetail.city
                dataSourse.insert(first, at: 0)
            }
            
            tableView?.reloadData()
        }
    }
    
    //保存数据
    func saveData() {
        let selectLocation:BMKPoiInfo = dataSourse[currentSelectLocationIndex!]
        
        let userDefault = UserDefaults.standard
        
        userDefault.set([selectLocation.pt.longitude,selectLocation.pt.latitude], forKey: "geographic")
        
        userDefault.synchronize()
        
        let recordModel = EV_RecordModel.init()
        
        let fileManager = EV_FileManager.init()
        
        var array:[Any] = fileManager.unArchiverReadRecords()
        
        array.append(recordModel)
        
        fileManager.archiverReadRecordsWithArray(readRecordsArray: array)

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.mode = MBProgressHUDModeText
        hud?.labelText = "保存成功"
        hud?.margin = 10.0
        hud?.hide(true, afterDelay: 0.5)
        
        let window:UIWindow = ((UIApplication.shared.delegate?.window)!)!
        
        window.rootViewController = ev_header.getTab()
        
        UIView.animate(withDuration: 1) { 
            UIView.setAnimationTransition(.flipFromRight, for: window, cache: false)
        }
    }
    
    
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        if mapView != nil{
            mapView = nil
        }
        if locService != nil {
            locService = nil
        }
        if geocodesearch != nil {
            geocodesearch = nil
        }
    }
}

//
//  ViewController.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/17.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate{

    let ev_header = EV_Header.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.layOutSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    func layOutSubView() {
        
        //导航栏高度和屏幕宽度
        let topHeight = ev_header.NavBarHeight + 20
        let screenWidth = ev_header.ScreenWidth
        
        //topView
        let navHeaderView = EV_NavHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: topHeight), titleString: "车辆计数")
        self.view.addSubview(navHeaderView)
        
        //车辆计数输入框、标题、按钮
        let titleArray = ["未上牌","已上牌"]
        
        for index in 0...1{
            //标题
            let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: topHeight + 20 + CGFloat((40 + 50 + 20) * index) , width: screenWidth, height: 40))
            titleLabel.text = titleArray[index] + "电动车数量"
            if #available(iOS 8.2, *) {
                titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
            } else {
                titleLabel.font = UIFont.systemFont(ofSize: 20)
                // Fallback on earlier versions
            }
            titleLabel.textAlignment = NSTextAlignment.init(rawValue: 1)!
            self.view.addSubview(titleLabel)
            
            //输入框
            let inputTextField =  UITextField.init(frame: CGRect.init(x: 40, y: titleLabel.frame.size.height + titleLabel.frame.origin.y , width: screenWidth - 80, height: 50))
            inputTextField.layer.masksToBounds = true
            inputTextField.layer.cornerRadius = 3.0
            inputTextField.layer.borderColor = ev_header.Base_gray.cgColor
            inputTextField.layer.borderWidth = 2.0
            inputTextField.text = "0"
            if #available(iOS 8.2, *) {
                inputTextField.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)
            } else {
                inputTextField.font = UIFont.systemFont(ofSize: 20)
                // Fallback on earlier versions
            }
            inputTextField.textAlignment = NSTextAlignment.init(rawValue: 1)!
            inputTextField.keyboardType = UIKeyboardType.phonePad
            inputTextField.tag = 200 + index
            inputTextField.delegate = self
            self.view.addSubview(inputTextField)
            
            //计数按钮
            let buttonWidth = (screenWidth - 20 * 3) / 2
            
            let countButton = UIButton.init(frame: CGRect.init(x: 20 + (20 + buttonWidth) * CGFloat(index), y: ev_header.ScreenHeight - 180 - buttonWidth, width: buttonWidth, height: buttonWidth))
            countButton.backgroundColor = ev_header.Shallow_Blue
            countButton.layer.masksToBounds = true
            countButton.layer.cornerRadius = buttonWidth/2
            countButton.setTitle(titleArray[index], for: UIControlState.normal)
            countButton.tag = 100 + index
            countButton.addTarget(self, action: #selector(buttonClick(button:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(countButton)
        }
        
        //下一步操作
        let nextButton = UIButton.init(frame: CGRect.init(x: 0, y: ev_header.ScreenHeight - 50 - 49, width: screenWidth, height: 50))
        nextButton.setTitle("完成计数，下一步", for: UIControlState.normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: UIControlEvents.touchUpInside)
        self.view.addSubview(nextButton)
        
        
        let backLayer:CAGradientLayer = EV_CAGradientLayer().gradientLayer(colors: [ev_header.Shallow_Blue.cgColor,ev_header.Shallow_Blue.cgColor], locations: [0.5,1.0])
        backLayer.frame = CGRect.init(x: 0, y: 0, width: nextButton.frame.size.width, height: nextButton.frame.size.height)
        nextButton.layer.addSublayer(backLayer)
    }
    
    func nextStep() {
        
        let licenseTF:UITextField = self.view.viewWithTag(200) as! UITextField
        let unlicenseTF:UITextField = self.view.viewWithTag(201) as! UITextField
        
        //先存储数据
        let userDefault = UserDefaults.standard
        
        userDefault.set(NSNumber.init(integerLiteral: Int(licenseTF.text!)!), forKey: "license")
        userDefault.set(NSNumber.init(integerLiteral: Int(unlicenseTF.text!)!), forKey: "unlicense")
        
        
        let infoVC = InfoViewController()
        infoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    func buttonClick(button:UIButton) {
        
        let index = button.tag - 100
        
        let textField:UITextField = self.view.viewWithTag(200 + index) as! UITextField
        var oldCount:NSInteger = NSInteger(textField.text!)!
        oldCount += 1
        textField.text = String(oldCount)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


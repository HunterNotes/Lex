//
//  AddressPickView.swift
//  Lex
//
//  Created by nbcb on 2016/12/23.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SnapKit

protocol AddressPickDelegate {
    
    func selectedCancel()
    func selectedConfirm(_ dic : Dictionary<String, Any>)
}

class AddressPickView: UIView {
    
    var adDelegate      : AddressPickDelegate?
    var dic             : Dictionary<String, Any>?
    
    var pickerDic       : NSDictionary!
    var provinceArray   : NSArray!
    var cityArray       : NSArray!
    var townArray       : NSArray!
    var selectedArray   : NSArray!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.dic = Dictionary()
        
        addPickView()
        getPickerData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -添加地址选择器
    fileprivate func addPickView() {
        
        self.addSubview(likeToolView)
        likeToolView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.size.equalTo(CGSize.init(width: app_width, height: 44))
        }
        
        self.addSubview(cityPickView)
        cityPickView.snp.makeConstraints { (make) in
            make.top.equalTo(44)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        likeToolView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(7)
            make.size.equalTo(CGSize.init(width: 40, height: 30))
        }
        
        likeToolView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(7)
            make.size.equalTo(CGSize.init(width: 40, height: 30))
        }
    }
    
    lazy var likeToolView : UIView = {
        
        let view : UIView = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    lazy var confirmBtn : UIButton = {
        
        let btn : UIButton = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(RGBA(41, g: 196, b: 117, a: 1.0), for: .normal)
        btn.addTarget(self, action: #selector(AddressPickView.confirmClick), for:
            .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    lazy var cancelBtn : UIButton = {
        
        let btn : UIButton = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(RGBA(165, g: 165, b: 165, a: 1.0), for: .normal)
        btn.addTarget(self, action: #selector(AddressPickView.cancelClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var cityPickView : UIPickerView = {
        
        let view : UIPickerView = UIPickerView()
        view.backgroundColor = UIColor.lightGray
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    //MARK: -pickerView
    func getSubViews(view : UIView) {
        
        for subView in view.subviews {
            if subView.subviews.count != 0 {
                self.getSubViews(view: subView)
            }
            else {
                if subView.frame.size.height <= 1 {
                    subView.backgroundColor = RGBA(41, g: 196, b: 117, a: 1.0)
                    subView.alpha = 0.5
                }
            }
        }
    }
    
    func confirmClick() {
        
        if self.adDelegate != nil {
            self.adDelegate?.selectedConfirm(self.dic!)
        }
    }
    
    func cancelClick() {
        
        if self.adDelegate != nil {
            self.adDelegate?.selectedCancel()
        }
    }
    
    //解析plist文件
    func getPickerData() {
        
        let path = Bundle.main.path(forResource: "Address", ofType: "plist")
        self.pickerDic = NSDictionary.init(contentsOfFile: path!)
        self.provinceArray = self.pickerDic.allKeys as NSArray!
        self.selectedArray = self.pickerDic.object(forKey: self.pickerDic.allKeys[0]) as! NSArray
        if (self.selectedArray.count > 0) {
            self.cityArray = (self.selectedArray[0] as AnyObject).allKeys as NSArray!
        }
        
        if (self.cityArray.count > 0) {
            self.townArray = (self.selectedArray[0] as AnyObject).object(forKey: self.cityArray[0]) as! NSArray
        }
    }
}

//MARK: UIPickerViewDelegate UIPickerViewDataSource
extension AddressPickView : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        self.getSubViews(view: pickerView)
        
        var pickerLabel = UILabel()
        pickerLabel = UILabel.init()
        //        pickerLabel.font = UIFont(name: "Helvetica", size: 8)
        pickerLabel.font = UIFont.systemFont(ofSize: 15)
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.textAlignment = .left
        pickerLabel.backgroundColor = UIColor.clear
        pickerLabel.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (component == 0) {
            return self.provinceArray.count;
        }
        else if (component == 1) {
            return self.cityArray.count
        }
        else {
            return self.townArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (component == 0) {
            
            //return [self.provinceArray objectAtIndex:row];
            return self.provinceArray[row] as? String
        }
        else if (component == 1) {
            return self.cityArray[row] as? String
        }
        else {
            return self.townArray[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if component == 0 {
            return 110
        }
        return app_width / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (component == 0) {
            self.selectedArray = self.pickerDic.object(forKey: self.provinceArray[row]) as! NSArray
            
            if (self.selectedArray.count > 0) {
                self.cityArray = (self.selectedArray[0] as AnyObject).allKeys as NSArray!
            }
            else {
                self.cityArray = nil;
            }
            
            if (self.cityArray.count > 0) {
                self.townArray = (self.selectedArray[0] as AnyObject).object(forKey: self.cityArray[0]) as! NSArray
            }
            else {
                self.townArray = nil;
            }
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        
        pickerView.selectedRow(inComponent: 1)
        pickerView.reloadComponent(1)
        pickerView.selectedRow(inComponent: 2)
        
        if (component == 1) {
            
            if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
                
                self.townArray = (self.selectedArray[0] as AnyObject).object(forKey: self.cityArray[row]) as! NSArray
            } else {
                self.townArray = nil;
            }
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }
        
        pickerView.reloadComponent(2)
        
        //        provinceBtn.setTitle(self.provinceArray[self.myPicker.selectedRowInComponent(0)] as? String, forState:.Normal)
        
        //省
        let state : String = (self.provinceArray[self.cityPickView.selectedRow(inComponent: 0)] as? String)!
        self.dic = ["state" : state]
        
        //市
        let city : String = (self.cityArray[self.cityPickView.selectedRow(inComponent: 1)] as? String)!
        self.dic = ["state" : state, "city" : city]
        
        //区
        let area : String = (self.townArray[self.cityPickView.selectedRow(inComponent: 2)]as? String)!
        self.dic = ["state" : state, "city" : city, "area" : area]
        
    }
}

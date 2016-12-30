//
//  UserNameVC.swift
//  Swift_Demo
//
//  Created by nbcb on 2016/11/15.
//  Copyright © 2016年 周清城. All rights reserved.
//

import UIKit
import Foundation

class UserNameVC: BaseViewController {
    
    @IBOutlet weak var iTextField: UITextField!
    @IBOutlet weak var clearBtn: UIButton!
    
    var leftItem       : UIBarButtonItem!
    var rightItem      : UIBarButtonItem!
    
    /// 编辑后的name 与原name相同，不保存
    var name           : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navTitle = "名字"
        self.iTextField.text = USERNAME
        if self.iTextField.text == nil {
            self.clearBtn.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.leftItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(left))
        self.leftItem.tintColor = UIColor.white
        self.rightItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(right))
        self.rightItem.tintColor = UIColor.green
        self.rightItem.isEnabled = false
        self.navigationItem.leftBarButtonItem = self.leftItem
        self.navigationItem.rightBarButtonItem = self.rightItem
        
//        self.iTextField.becomeFirstResponder()
    }
    
    func left() {
        
        self.doBack()
    }
    
    func right() {
        
        if USERNAME != name {
            USERNAME = name
        }
        self.doBack()
    }
    
    func doBack() {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clear(_ sender: AnyObject) {
        
        if self.iTextField.text != "" && self.iTextField.text != nil {
            
            self.iTextField.text = ""
            self.clearBtn.isHidden = true
        }
    }
}

//MARK: - UITextFieldDelegate
extension UserNameVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text : String = textField.text!
        
        if (self.iTextField.text == "" || self.iTextField.text == nil) {
            
            self.clearBtn.isHidden = true
            if string != "" {
                self.clearBtn.isHidden = false
            }
        }
        else {
            
            self.clearBtn.isHidden = false
            if self.iTextField.text?.characters.count == 1 && string == "" { //最后一位回删
                self.clearBtn.isHidden = true
            }
        }
        if string == "" {
            
            //删除
            if Int(text.characters.count) > 0 {
                
                //定位到截取位置
                let index : Int = Int(text.characters.count - 1)
                
                //将String类型转为NSString，再截取
                name = (text as NSString).substring(to: index)
            }
        }
        else {
            
            //输入
            name = textField.text! + string
        }
        
        if Int(name.characters.count) == 0 {
            
            self.clearBtn.isHidden = true
        }
        else {
            self.clearBtn.isHidden = false
        }
        
        if USERNAME == name {
            self.rightItem.isEnabled = false
        }
        else {
            self.rightItem.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        name = textField.text!
        textField.resignFirstResponder()
        if Int((USERNAME?.characters.count)!) != 0 && USERNAME != textField.text {
            USERNAME = textField.text
            
            self.doBack()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.iTextField.resignFirstResponder()
    }
}

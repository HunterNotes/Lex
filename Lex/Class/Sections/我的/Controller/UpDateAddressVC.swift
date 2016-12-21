//
//  UpDateAddressVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/21.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
//import AddressBook
//import AddressBookUI

class UpDateAddressVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titleArr        : [String]!
    var name            : String? = ""
    var phoneNum        : String? = ""
    var address         : String? = ""
    var addressDetail   : String? = ""
    var locality        : String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "修改地址"
        
        titleArr = ["姓名", "手机号码", "选择地区", "", "邮编"]
        self.registerCell()
    }
    
    func registerCell() {
        
        self.tableView.register(UINib.init(nibName: "EditAddressCommonCell", bundle: nil), forCellReuseIdentifier: "EditAddressCommonCell")
        self.tableView.register(UINib.init(nibName: "AddressDetailCell", bundle: nil), forCellReuseIdentifier: "AddressDetailCell")
    }
    
    @objc func edit(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            //            let picker = ABPeoplePickerNavigationController()
            //            picker.peoplePickerDelegate = self
            //            self.present(picker, animated: true) { () -> Void in
            //            }
            
            if #available(iOS 9.0, *) {
                
                let cpvc = CNContactPickerViewController()
                cpvc.delegate = self
                present(cpvc, animated: true, completion: nil)
            }
            else {
                // Fallback on earlier versions
            }
            
        }
        else if sender.tag == 2 {
            
        }
    }
}

extension UpDateAddressVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row     : Int = (indexPath as NSIndexPath).row
        
        if row == 3 {
            
            return 60
        }
        else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row: Int = (indexPath as NSIndexPath).row
        
        if row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressDetailCell", for: indexPath)
                as! AddressDetailCell
            cell.selectionStyle = .none
            cell.leftLab.text = "详细地址"
            cell.textView.placeholder = "街道门牌信息"
            
            return cell
        }
        else {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "EditAddressCommonCell", for: indexPath)
                as! EditAddressCommonCell
            cell1.selectionStyle = .none
            cell1.button.tag = row
            cell1.button.addTarget(self, action: #selector(edit(_:)), for: .touchUpInside)
            cell1.leftLab.text = self.titleArr[row]
            switch row {
            case 0:
                cell1.textField.placeholder = "名字"
                cell1.button.isHidden = false
                cell1.textField.text = self.name
                cell1.button.setImage(UIImage.init(named: "contacts"), for: .normal)
                break
            case 1:
                cell1.textField.placeholder = "11位手机号"
                cell1.textField.text = self.phoneNum
                cell1.button.isHidden = true
                break
            case 2:
                cell1.textField.placeholder = "地区信息"
                cell1.textField.text = self.addressDetail
                cell1.button.isHidden = false
                cell1.button.setImage(UIImage.init(named: "loaction"), for: .normal)
                break
            case 4:
                cell1.textField.placeholder = "邮政编码"
                cell1.button.isHidden = true
                break
            default:
                break
            }
            return cell1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row     : Int = (indexPath as NSIndexPath).row
        
        if row == 0 {
            
            //            let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoVC
            //            self.pushVC(self.view, vc)
        }
    }
}

//MARK: ABPeoplePickerNavigationControllerDelegate
//extension UpDateAddressVC: ABPeoplePickerNavigationControllerDelegate {
//    
//    
//    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController,
//                                          didSelectPerson person: ABRecord) {
//        //获取姓
//        let lastName = ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue()
//            as! String
//        //获取名
//        let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue()
//            as! String
//        
//        self.name = "\(lastName)\(firstName)"
//        print("姓名：", self.name ?? "")
//        
//        //获取电话
//        let phoneValues: ABMutableMultiValue? =
//            ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
//        
//        if phoneValues != nil {
//            
//            self.phoneNum = "\(phoneValues)"
//            print("电话：\(phoneValues)")
//        }
//        
//        //获取地址
//        let addressValues:ABMutableMultiValue? =
//            ABRecordCopyValue(person, kABPersonAddressProperty).takeRetainedValue()
//        
//        if addressValues != nil {
//            
//            self.addressDetail = "\(addressValues)"
//            print("地址：\(addressValues)")
//            
//            for i in 0 ..< ABMultiValueGetCount(addressValues) {
//                
//                // 获得标签名
//                let label = ABMultiValueCopyLabelAtIndex(addressValues, i).takeRetainedValue()
//                    as CFString;
//                let localizedLabel = ABAddressBookCopyLocalizedLabel(label)
//                    .takeRetainedValue() as String
//                
//                let value = ABMultiValueCopyValueAtIndex(addressValues, i)
//                let addrNSDict:NSMutableDictionary = value!.takeRetainedValue()
//                    as! NSMutableDictionary
//                let country: String = addrNSDict.value(forKey: kABPersonAddressCountryKey as String)
//                    as? String ?? ""
//                let state: String = addrNSDict.value(forKey: kABPersonAddressStateKey as String)
//                    as? String ?? ""
//                let city: String = addrNSDict.value(forKey: kABPersonAddressCityKey as String)
//                    as? String ?? ""
//                let street: String = addrNSDict.value(forKey: kABPersonAddressStreetKey as String)
//                    as? String ?? ""
//                let contryCode: String = addrNSDict
//                    .value(forKey: kABPersonAddressCountryCodeKey as String) as? String ?? ""
//                print("\(localizedLabel): Contry:\(country) State:\(state) ")
//                print("City:\(city) Street:\(street) ContryCode:\(contryCode) ")
//            }
//        }
//        self.tableView.reloadData()
//    }
//    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController,
//                                          didSelectPerson person: ABRecord, property: ABPropertyID,
//                                          identifier: ABMultiValueIdentifier) {
//        
//    }
//    
//    //取消按钮点击
//    func peoplePickerNavigationControllerDidCancel(_ peoplePicker: ABPeoplePickerNavigationController) {
//        
//        //去除地址选择界面
//        peoplePicker.dismiss(animated: true, completion: { () -> Void in
//            
//        })
//    }
//    
//    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController,
//                                          shouldContinueAfterSelectingPerson person: ABRecord) -> Bool {
//        return true
//    }
//    
//    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController,
//                                          shouldContinueAfterSelectingPerson person: ABRecord, property: ABPropertyID,
//                                          identifier: ABMultiValueIdentifier) -> Bool {
//        return true
//    }
//}

extension UpDateAddressVC:  CNContactPickerDelegate {
    
    @available(iOS 9.0, *)
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        // 1.获取用户的姓名
        let lastname = contact.familyName
        let firstname = contact.givenName
        self.name = lastname + firstname
        print("姓名:", self.name ?? "")
        
        // 2.获取用户电话号码(ABMultivalue)
        let phones = contact.phoneNumbers
        for phone in phones {
            let phoneLabel = phone.label
            let phoneValue = phone.value.stringValue
            print("phoneLabel:\(phoneLabel). phoneValue:\(phoneValue)")
            
            let num : String = "\(phoneValue)"
            self.phoneNum = num.replacingOccurrences(of: "-", with: "")
            print(self.phoneNum ?? "")
        }
        
        self.tableView.reloadData()
    }
    
    //这个方法和上面的方法是一样的,只是它是获取多个联系人的信息
//    @available(iOS 9.0, *)
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//        
//    }
    
    @available(iOS 9.0, *)
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}

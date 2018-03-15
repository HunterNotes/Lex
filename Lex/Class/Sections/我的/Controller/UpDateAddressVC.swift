//
//  UpDateAddressVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/21.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SVProgressHUD
import Contacts
import ContactsUI


protocol UpDateAddressVCDelegate {
    
    func upDateAddress(_ address : String)
}

class UpDateAddressVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentField    : UITextField!
    var textView        : UITextView!
    
    var titleArr        : [String]!
    var index           : Int!
    
    /* 通讯录信息 */
    var name            : String? = ""
    var phoneNum        : String? = "18888888888"
    var locality        : String? = ""
    var addressDetail   : String? = ""
    var postalCode      : String? = CCSingleton.sharedUser().postalCode
    
    /* 地址 */
    var state           : String? = ""
    var city            : String? = ""
    var area            : String? = ""
    var isPopPickViwe   : Bool?   = false
    
    var upDateAddressDelegate : UpDateAddressVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置状态栏的文字颜色
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.view.addSubview(self.naBar)
        self.naBar.naBarItem.text = self.title
        self.view.addSubview(self.pickerView)
        
        titleArr = ["姓名", "手机号码", "选择地区", "", "邮编"]
        self.name = USERNAME!
        
        let singleton : CCSingleton = CCSingleton.sharedUser()
        self.locality = singleton.state! + "  " + singleton.city! + "  " + singleton.subLocality!
        self.addressDetail = singleton.thoroughfare!
        
        self.registerCell()
        
        weak var weakSelf = self
        ReturnLocationHelper.sharedManager().locationBlock = { (isFinish : Bool, mapPOI : AMapPOI) -> () in
            
            if isFinish {
                
                weakSelf?.state = mapPOI.province
                weakSelf?.city = mapPOI.city
                weakSelf?.area = mapPOI.district
                weakSelf?.postalCode = mapPOI.postcode
                
                weakSelf?.locality = weakSelf!.state! + "  " + weakSelf!.city! + "  " + weakSelf!.area!
                weakSelf?.addressDetail = mapPOI.address
                weakSelf?.tableView.reloadData()
            }
        }
    }
    
    func registerCell() {
        
        self.tableView.register(UINib.init(nibName: "EditAddressCommonCell", bundle: nil), forCellReuseIdentifier: "EditAddressCommonCell")
        self.tableView.register(UINib.init(nibName: "AddressDetailCell", bundle: nil), forCellReuseIdentifier: "AddressDetailCell")
    }
    
    lazy var naBar: PresentNaBarView = {
        
        let bar : PresentNaBarView = PresentNaBarView.init(frame: CGRect.init(x: 0, y: 0, width: app_width, height: 64));
        bar.backgroundColor = nav_color()
        bar.cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        bar.saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
        return bar
    }()
    
    lazy var pickerView : AddressPickView = {
        
        let rec : CGRect = CGRect.init(x: 0, y: app_height, width: app_width, height: 244)
        let pick : AddressPickView = AddressPickView.init(frame: rec)
        pick.backgroundColor = UIColor.white
        pick.adDelegate = self
        return pick
    }()
    
    func setPickViewFrame() {
        
        self.isPopPickViwe = !self.isPopPickViwe!
        
        if self.isPopPickViwe == false {
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                
                self.dismissPickerView()
                
            }, completion: { (finish : Bool) in
                
            })
        }
        else {
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                
                self.popPickerView()
                
            }, completion: { (finish : Bool) in
                
            })
        }
    }
    
    func popPickerView() {
        
        self.pickerView.frame = CGRect.init(x: 0, y: app_height - 244, width: app_width, height: 244)
    }
    
    func dismissPickerView() {
        
        self.pickerView.frame = CGRect.init(x: 0, y: app_height, width: app_width, height: 244)
    }
    
    //MARK: action
    func cancel() {
        
        let alertVC : UIAlertController = UIAlertController.init(title: nil, message: "确定放弃此次编辑", preferredStyle: .alert)
        let cancelAction : UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let confirmAction : UIAlertAction = UIAlertAction.init(title: "确定", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func save() {
        
        if self.addressDetail?.count > 0 {
            if self.upDateAddressDelegate != nil {
                
                let address : String = "\(self.state!)" + "\(self.city!)" + "\(self.area!)" + "\(self.addressDetail!)"
                self.upDateAddressDelegate?.upDateAddress(address)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func edit(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            if #available(iOS 9.0, *) {
                
                let cpvc = CNContactPickerViewController()
                cpvc.delegate = self
                present(cpvc, animated: true, completion: nil)
            }
            else {
                SVProgressHUD.showError(withStatus: "仅支持iOS9及以上系统")
            }
        }
        else if sender.tag == 2 {
            
            let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.isEditing = true
    }
}

//MARK: UITableViewDataSource UITableViewDelegate
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
            cell.textView.delegate = self
            cell.textView.placeholder = "街道门牌信息"
            cell.textView.text = self.addressDetail!
            return cell
        }
        else {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "EditAddressCommonCell", for: indexPath)
                as! EditAddressCommonCell
            cell1.selectionStyle = .none
            cell1.textField.isEnabled = true
            cell1.textField.delegate = self
            cell1.button.tag = row
            cell1.button.addTarget(self, action: #selector(edit(_:)), for: .touchUpInside)
            cell1.leftLab.text = self.titleArr[row]
            switch row {
            case 0:
                cell1.textField.placeholder = "名字"
                cell1.button.isHidden = false
                cell1.textField.text = self.name!
                cell1.button.setImage(UIImage.init(named: "contacts"), for: .normal)
                break
            case 1:
                cell1.textField.placeholder = "11位手机号"
                cell1.textField.text = self.phoneNum!
                cell1.button.isHidden = true
                break
            case 2:
                cell1.textField.placeholder = "地区信息"
                cell1.textField.isEnabled = false
                cell1.textField.text = self.locality!
                cell1.button.isHidden = false
                cell1.button.setImage(UIImage.init(named: "loaction"), for: .normal)
                break
            case 4:
                cell1.textField.placeholder = "邮政编码"
                cell1.textField.text = self.postalCode
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
        
        if row == 2 {
            
            self.setPickViewFrame()
        }
        else {
            self.dismissPickerView()
        }
    }
}
//MARK: UITextViewDelegate
extension UpDateAddressVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.textView = textView
        self.naBar.saveBtn.isEnabled = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    
}

//MARK: UITextFieldDelegate
extension UpDateAddressVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.currentField = textField
        self.naBar.saveBtn.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
}

//MARK: CNContactPickerDelegate
extension UpDateAddressVC:  CNContactPickerDelegate {
    
    @available(iOS 9.0, *)
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        // 1.获取用户的姓名
        let lastname = contact.familyName
        let firstname = contact.givenName
        self.name = lastname + firstname
        CCLog("姓名:"+(self.name ?? ""))
        
        // 2.获取用户电话号码(ABMultivalue)
        let phones = contact.phoneNumbers
        for phone in phones {
            let phoneLabel = phone.label
            let phoneValue = phone.value.stringValue
            CCLog("phoneLabel:\(phoneLabel ?? ""). phoneValue:\(phoneValue)")
            
            let num : String = "\(phoneValue)"
            self.phoneNum = num.replacingOccurrences(of: "-", with: "")
            CCLog(self.phoneNum ?? "")
        }
        self.tableView.reloadData()
    }
    
    //获取多个联系人的信息
    //    @available(iOS 9.0, *)
    //    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
    //
    //    }
    
    @available(iOS 9.0, *)
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}

//MARK: AddressPickDelegate
extension UpDateAddressVC : AddressPickDelegate {
    
    func selectedCancel() {
        
        self.setPickViewFrame()
    }
    
    func selectedConfirm(_ dic: Dictionary<String, Any>) {
        
        if dic.count > 0 {
            
            self.state = dic["state"] as! String?
            self.city = dic["city"] as! String?
            self.area = dic["area"] as! String?
            
            self.locality = "\(self.state!) +   \(self.city!) +   \(self.area!)"
            self.tableView.reloadData()
        }
        
        self.setPickViewFrame()
    }
}

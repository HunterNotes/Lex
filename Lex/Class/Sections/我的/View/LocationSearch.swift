//
//  LocationSearch.swift
//  Lex
//
//  Created by nbcb on 2016/12/27.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

protocol LocationSearchDelegate {
    func hideSearchView(status : Bool)
}

class LocationSearch: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AMapSearchDelegate {
    
    //MARK: Properties
    let statusView: UIView = {
        
        let rec : CGRect = CGRect.init(x: 0, y: 0, width: app_width, height: 20)
        //        rec =  UIApplication.shared.statusBarFrame
        let st = UIView.init(frame: rec)
        st.backgroundColor = globalBGColor()
        //        st.backgroundColor = UIColor.black
        //        st.alpha = 0.15
        return st
    }()
    
    lazy var backgroundView: UIView = {
        
        let bv = UIView.init(frame: self.frame)
        bv.backgroundColor = UIColor.black
        bv.alpha = 0
        return bv
    }()
    
    lazy var searchView: UIView = {
        
        let sv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 68))
        sv.backgroundColor = globalBGColor()
        //        sv.alpha = 0
        return sv
    }()
    
    lazy var searchBGView: UIView = {
        
        let rec : CGRect = CGRect.init(x: 9, y: 30, width: self.width - 58, height: 28)
        var sv = UIView.init(frame: rec)
        sv.backgroundColor = UIColor.white
        sv.drawCorner(.allCorners, 5, .clear, 0.5)
        return sv
    }()
    
    private lazy var iconButton: UIButton = {
        
        let bb = UIButton.init(frame: CGRect.init(x: 10, y: 34, width: 20, height: 20))
        bb.setBackgroundImage(UIImage.init(named: "error_image_search"), for: .normal)
        bb.adjustsImageWhenHighlighted = false
        return bb
    }()
    
    lazy var searchField: UITextField = {
        
        let sf = UITextField.init(frame: CGRect.init(x: 30, y: 34, width: self.width - 118, height: 20))
        sf.placeholder = "Seach on Youtube"
        sf.font = UIFont.systemFont(ofSize: 15.0)
        sf.keyboardAppearance = .dark
        sf.delegate = self
        return sf
    }()
    
    lazy var deleteButton: UIButton = {
        
        let bb = UIButton.init(frame: CGRect.init(x: app_width - 86, y: 30, width: 28, height: 28))
        bb.setImage(UIImage.init(named: "main_ad_close"), for: .normal)
        bb.imageEdgeInsets = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        bb.isHidden = true
        bb.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        return bb
    }()
    
    lazy var backButton: UIButton = {
        
        let bb = UIButton.init(frame: CGRect.init(x: app_width - 58, y: 20, width: 48, height: 48))
        bb.setBackgroundImage(UIImage.init(named: "cancel"), for: [])
        bb.backgroundColor = globalBGColor()
        bb.setTitle("取消", for: .normal)
        bb.titleLabel?.textAlignment = .right
        bb.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        bb.setTitleColor(.green, for: .normal)
        bb.addTarget(self, action: #selector(LocationSearch.dismiss), for: .touchUpInside)
        return bb
    }()
    
    lazy var tableView: UITableView = {
        
        let tv: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 68, width: self.width, height: app_height - 68), style: UITableViewStyle.plain)
        //            .init(frame: CGRect.init(x: 0, y: 68, width: self.width, height: app_height - 68)) //288
        tv.backgroundColor = RGBA(245, g: 245, b: 245, a: 1.0)
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        return tv
    }()
    
    var delegate: LocationSearchDelegate?
    
    //MARK: 搜索位置
    lazy var mapSearch : AMapSearchAPI = {
        
        let mapSearch : AMapSearchAPI = AMapSearchAPI()
        mapSearch.delegate = self
        return mapSearch
    }()
    
    lazy var mapRequest : AMapInputTipsSearchRequest = {
        
        let request : AMapInputTipsSearchRequest = AMapInputTipsSearchRequest()
        request.types = "汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施"
        
        //城市
        //        request.city = CCSingleton.sharedUser().city
        
        return request
    }()
    
    var items : Array<AMapTip> = {
        
        let arr : Array = Array<AMapTip>()
        return arr
    }()
    
    //MARK: Methods
    func customization() {
        
        self.addSubview(self.backgroundView)
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(LocationSearch.dismiss)))
        self.addSubview(self.searchView)
        self.searchView.addSubview(self.statusView)
        self.searchView.addSubview(self.searchBGView)
        self.searchView.addSubview(self.iconButton)
        self.searchView.addSubview(self.searchField)
        self.searchView.addSubview(self.deleteButton)
        self.searchView.addSubview(self.backButton)
        self.tableView.register(LocationSearchCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func animate() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0.5
            self.searchView.alpha = 1
            self.searchField.becomeFirstResponder()
        })
    }
    
    @objc func deleteAction(_ sender : UIButton) {
        
        if (self.searchField.text != "" && self.searchField.text != nil) {
            self.searchField.text = ""
            sender.isHidden = true
        }
    }
    
    func dismiss()  {
        
        self.searchField.text = ""
        self.items.removeAll()
        self.tableView.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0
            self.searchView.alpha = 0
            self.searchField.resignFirstResponder()
        }, completion: {(Bool) in
            self.delegate?.hideSearchView(status: true)
        })
    }
    
    //MARK: TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (self.searchField.text == "" || self.searchField.text == nil) {
            
            self.deleteButton.isHidden = true
            if string != "" {
                self.deleteButton.isHidden = false
            }
            
            self.items = []
            self.tableView.removeFromSuperview()
        }
        else {
            
            self.deleteButton.isHidden = false
            if self.searchField.text?.characters.count == 1 && string == "" { //最后一位回删
                self.deleteButton.isHidden = true
            }
            
            //关键字
            self.mapRequest.keywords = textField.text
            self.mapSearch.aMapInputTipsSearch(self.mapRequest) //搜索请求
            //            let _  = URLSession.shared.dataTask(with: requestSuggestionsURL(text: self.searchField.text!), completionHandler: { (data, response, error) in
            //                if error == nil {
            //                    do {
            //                        let json  = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
            ////                        self.items = json[1] as! [String]
            //                        DispatchQueue.main.async(execute: {
            //                            if self.items.count > 0  {
            //                                self.addSubview(self.tableView)
            //                            }
            //                            else {
            //                                self.tableView.removeFromSuperview()
            //                            }
            //                            self.tableView.reloadData()
            //                        })
            //                    }
            //                    catch _ {
            //                        print("Something wrong happened")
            //                    }
            //                }
            //                else {
            //                    print("error downloading suggestions")
            //                }
            //            }).resume()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismiss()
        return true
    }
    
    //MARK: TableView Delegates and Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.items.count == 0 {
            return 1
        }
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LocationSearchCell
        if self.items.count > 0 {
            cell.itemLabel.text = self.items[indexPath.row].name
        }
        cell.backgroundColor = RGBA(245, g: 245, b: 245, a: 1.0)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row : Int = (indexPath as NSIndexPath).row
        
        if self.items.count > 0 {
            
            let mapTip : AMapTip = self.items[row]
            CCSingleton.sharedUser().latitude = CLLocationDegrees(mapTip.location.latitude)
            CCSingleton.sharedUser().longitude = CLLocationDegrees(mapTip.location.longitude)
            
            self.dismiss()
        }
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchField.resignFirstResponder()
    }
    
    //MARK: AMapSearchDelegate
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        
        if response.tips.count == 0 {
            return
        }
        
        self.items = response.tips
        if self.items.count > 0  {
            self.addSubview(self.tableView)
        }
        else {
            self.tableView.removeFromSuperview()
        }
        self.tableView.reloadData()
    }
    
    //MARK: Inits
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        customization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        //        self.tableView.separatorStyle = .none
    }
}

class LocationSearchCell: UITableViewCell {
    
    lazy var itemLabel: UILabel = {
        let il: UILabel = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: self.contentView.bounds.width - 40, height: self.contentView.bounds.height))
        il.textColor = UIColor.gray
        return il
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "Cell")
        self.addSubview(itemLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

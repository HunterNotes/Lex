//
//  Search.swift
//  Lex
//
//  Created by nbcb on 2016/12/27.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

protocol SearchDelegate {
    func hideSearchView(status : Bool)
}

class Search: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
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
        bb.addTarget(self, action: #selector(Search.dismiss), for: .touchUpInside)
        return bb
    }()
    
    lazy var tableView: UITableView = {
        
        let tv: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 68, width: self.width, height: 288))
        return tv
    }()
    var items = [String]()
    
    var delegate: SearchDelegate?
    
    //MARK: Methods
    func customization() {
        
        self.addSubview(self.backgroundView)
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(Search.dismiss)))
        self.addSubview(self.searchView)
        self.searchView.addSubview(self.statusView)
        self.searchView.addSubview(self.searchBGView)
        self.searchView.addSubview(self.iconButton)
        self.searchView.addSubview(self.searchField)
        self.searchView.addSubview(self.deleteButton)
        self.searchView.addSubview(self.backButton)
        self.tableView.register(searchCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.clear
        self.searchField.delegate = self
//        self.addSubview(self.statusView)
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
            
            let _  = URLSession.shared.dataTask(with: requestSuggestionsURL(text: self.searchField.text!), completionHandler: { (data, response, error) in
                if error == nil {
                    do {
                        let json  = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                        self.items = json[1] as! [String]
                        DispatchQueue.main.async(execute: {
                            if self.items.count > 0  {
                                self.addSubview(self.tableView)
                            }
                            else {
                                self.tableView.removeFromSuperview()
                            }
                            self.tableView.reloadData()
                        })
                    }
                    catch _ {
                        print("Something wrong happened")
                    }
                }
                else {
                    print("error downloading suggestions")
                }
            }).resume()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismiss()
        return true
    }
    
    //MARK: TableView Delegates and Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! searchCell
        cell.itemLabel.text = items[indexPath.row]
        cell.backgroundColor = RGBA(245, g: 245, b: 245, a: 1.0)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.searchField.text = items[indexPath.row]
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
        
        self.tableView.separatorStyle = .none
    }
}

class searchCell: UITableViewCell {
    
    lazy var itemLabel: UILabel = {
        let il: UILabel = UILabel.init(frame: CGRect.init(x: 48, y: 0, width: self.contentView.bounds.width - 48, height: self.contentView.bounds.height))
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

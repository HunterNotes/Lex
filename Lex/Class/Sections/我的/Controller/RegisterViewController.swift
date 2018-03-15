//
//  RegisterViewController.swift
//  Lex
//
//  Created by nbcb on 2016/12/13.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var mobileField: UITextField!
    
    @IBOutlet weak var vertifyButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mobileField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

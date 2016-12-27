//
//  ScanCodeResultVC.swift
//  Lex
//
//  Created by nbcb on 2016/12/19.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import UIKit
import SVProgressHUD

class ScanCodeResultVC: BaseViewController {
    
    var urlStr                  : String!
    lazy var webView : UIWebView = {
        
        let web : UIWebView = UIWebView.init(frame: CGRect.init(x: 0, y: 64, width: app_width, height: app_height))
        return web
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "扫描结果"
        self.view.addSubview(webView)
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string: urlStr)! as URL) as URLRequest)
    }
}

extension ScanCodeResultVC : UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.show(withStatus: "加载中……")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        SVProgressHUD.showError(withStatus: error.localizedDescription)
        print(error.localizedDescription)
    }
}

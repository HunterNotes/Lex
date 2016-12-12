//
//  NetworkManager.swift
//  Lex
//
//  Created by nbcb on 2016/12/12.
//  Copyright © 2016年 ZQC. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import SwiftyJSON

class NetworkManager: NSObject {
    
    //MARK: 单例
    class func shareNetwork() -> NetworkManager {
        
        struct network {
            static var manager : NetworkManager = NetworkManager()
        }
        return network.manager
    }
    
    /// 获取首页数据
    func loadHomeInfo(_ id: Int, finished:@escaping (_ homeItems: [NavItem]) -> ()) {
        
        //        let url = BASE_URL + "v1/channels/\(id)/items?gender=1&generation=1&limit=20&offset=0"
        let url = BASE_URL + "v1/channels/\(id)/items"
        let params : [String : Int] = ["gender": 1,
                                       "generation": 1,
                                       "limit": 20,
                                       "offset": 0]
        //        let dataRequest : DataRequest =
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    let data = dict["data"].dictionary
                    //  字典转成模型
                    if let items = data!["items"]?.arrayObject {
                        var homeItems = [NavItem]()
                        for item in items {
                            let homeItem = NavItem(dict: item as! [String: AnyObject])
                            homeItems.append(homeItem)
                        }
                        finished(homeItems)
                    }
                }
        }
    }
    
    /// 获取首页顶部选择数据
    func loadHomeTopData(_ finished:@escaping (_ ym_channels: [Navigation]) -> ()) {
        
        let url = BASE_URL + "v2/channels/preset"
        let params : [String : Int] = ["gender": 1,
                                       "generation": 1]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    SVProgressHUD.dismiss()
                    let data = dict["data"].dictionary
                    if let channels = data!["channels"]?.arrayObject {
                        var ym_channels = [Navigation]()
                        for channel in channels {
                            let ym_channel = Navigation(dict: channel as! [String: AnyObject])
                            ym_channels.append(ym_channel)
                        }
                        finished(ym_channels)
                    }
                }
            })
    }
    
    /// 搜索界面数据
    func loadHotWords(_ finished:@escaping (_ words: [String]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v1/search/hot_words"
        
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    SVProgressHUD.dismiss()
                    if let data = dict["data"].dictionary {
                        if let hot_words = data["hot_words"]?.arrayObject {
                            finished(hot_words as! [String])
                        }
                    }
                }
        }
    }
    
    /// 根据搜索条件进行搜索
    func loadSearchResult(_ keyword: String, sort: String, finished:@escaping (_ results: [SearchResult]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = "http://api.dantangapp.com/v1/search/item"
        
        let params = ["keyword": keyword,
                      "limit": 20,
                      "offset": 0,
                      "sort": sort] as [String : Any]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    SVProgressHUD.dismiss()
                    let data = dict["data"].dictionary
                    if let items = data!["items"]?.arrayObject {
                        var results = [SearchResult]()
                        for item in items {
                            let result = SearchResult(dict: item as! [String: AnyObject])
                            results.append(result)
                        }
                        finished(results)
                    }
                }
        }
    }
    
    /// 获取单品数据
    func loadProductData(_ finished:@escaping (_ products: [Product]) -> ()) {
        
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v2/items"
        let params : [String : Int] = ["gender" : 1,
                                       "generation" : 1,
                                       "limit" : 20,
                                       "offset" : 0]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    SVProgressHUD.dismiss()
                    if let data = dict["data"].dictionary {
                        if let items = data["items"]?.arrayObject {
                            var products = [Product]()
                            
                            let count : Int = items.count - 1
                            for i in 0...count {
                                
                                let item : [String : [AnyObject]] = items[i] as! [String : [AnyObject]]
                                if let itemData = item["data"] {
                                    let product = Product(dict: itemData as! [String: AnyObject])
                                    products.append(product)
                                }
                            }
                            finished(products)
                        }
                    }
                }
        }
    }
    
    /// 获取单品详情数据
    func loadProductDetailData(_ id: Int, finished:@escaping (_ productDetail: ProductDetail) -> ()) {
        
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v2/items/\(id)"
        
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    SVProgressHUD.dismiss()
                    if let data = dict["data"].dictionaryObject {
                        let productDetail = ProductDetail(dict: data as [String : AnyObject])
                        finished(productDetail)
                    }
                }
        }
    }
    
    /// 商品详情 评论
    func loadProductDetailComments(_ id: Int, finished:@escaping (_ comments: [Comment]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v2/items/\(id)/comments"
        let params : [String : Int] = ["limit"  : 20,
                                       "offset" : 0]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    SVProgressHUD.dismiss()
                    if let data = dict["data"].dictionary {
                        if let commentsData = data["comments"]?.arrayObject {
                            var comments = [Comment]()
                            for item in commentsData {
                                let comment = Comment(dict: item as! [String: AnyObject])
                                comments.append(comment)
                            }
                            finished(comments)
                        }
                    }
                }
        }
    }
    
    /// 分类界面 顶部 专题合集
    func loadCategoryCollection(_ limit: Int, finished:@escaping (_ collections: [Collection]) -> ()) {
        
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v1/collections"
        let params = ["limit": limit,
                      "offset": 0]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    SVProgressHUD.dismiss()
                    if let data = dict["data"].dictionary {
                        if let collectionsData = data["collections"]?.arrayObject {
                            var collections = [Collection]()
                            for item in collectionsData {
                                let collection = Collection(dict: item as! [String: AnyObject])
                                collections.append(collection)
                            }
                            finished(collections)
                        }
                    }
                }
        }
    }
    
    /// 顶部 专题合集 -> 专题列表
    func loadCollectionPosts(_ id: Int, finished:@escaping (_ posts: [CollectionPost]) -> ()) {
        
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v1/collections/\(id)/posts"
        let params = ["gender": 1,
                      "generation": 1,
                      "limit": 20,
                      "offset": 0]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    SVProgressHUD.dismiss()
                    if let data = dict["data"].dictionary {
                        if let postsData = data["posts"]?.arrayObject {
                            var posts = [CollectionPost]()
                            for item in postsData {
                                let post = CollectionPost(dict: item as! [String: AnyObject])
                                posts.append(post)
                            }
                            finished(posts)
                        }
                    }
                }
        }
    }
    
    /// 分类界面 风格,品类
    func loadCategoryGroup(_ finished:@escaping (_ outGroups: [AnyObject]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v1/channel_groups/all"
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    SVProgressHUD.dismiss()
                    if let data = dict["data"].dictionary {
                        if let channel_groups = data["channel_groups"]?.arrayObject {
                            // outGroups 存储两个 inGroups 数组，inGroups 存储 YMGroup 对象
                            // outGroups 是一个二维数组
                            var outGroups = [AnyObject]()
                            let count : Int = channel_groups.count - 1
                            
                            for i in 0...count {
                                
                                let channel_group : [String : [AnyObject]] = channel_groups[i] as! [String : [AnyObject]]
                                var inGroups = [Group]()
                                let channels = channel_group["channels"]
                                
                                for channel in channels! {
                                    let group = Group(dict: channel as! [String: AnyObject])
                                    inGroups.append(group)
                                }
                                outGroups.append(inGroups as AnyObject)
                            }
                            finished(outGroups)
                        }
                    }
                }
        }
    }
    
    /// 底部 风格品类 -> 列表
    func loadStylesOrCategoryInfo(_ id: Int, finished:@escaping (_ items: [CollectionPost]) -> ()) {
        SVProgressHUD.show(withStatus: "正在加载...")
        let url = BASE_URL + "v1/channels/\(id)/items"
        let params = ["limit": 20,
                      "offset": 0]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let dict = JSON(value)
                    let code = dict["code"].intValue
                    let message = dict["message"].stringValue
                    guard code == RETURN_OK else {
                        SVProgressHUD.showInfo(withStatus: message)
                        return
                    }
                    SVProgressHUD.dismiss()
                    if let data = dict["data"].dictionary {
                        if let itemsData = data["items"]?.arrayObject {
                            var items = [CollectionPost]()
                            for item in itemsData {
                                let post = CollectionPost(dict: item as! [String: AnyObject])
                                items.append(post)
                            }
                            finished(items)
                        }
                    }
                }
        }
    }
}

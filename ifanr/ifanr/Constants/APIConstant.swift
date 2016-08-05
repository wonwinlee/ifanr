//
//  APIConstant.swift
//  ifanr
//
//  Created by 梁亦明 on 16/7/1.
//  Copyright © 2016年 ifanrOrg. All rights reserved.
//

import UIKit
import Foundation
import Moya
   
public enum APIConstant {
    /**
     *  首页-热门（5条导航）参数 page, posts_per_page
     *
     *  @param Int    page请求的页数
     *
     */
    case Home_hot_features(Int)
    
    /**
     *  首页-列表 每次请求12条
     *
     *  @param Int 参数page 分页数从1开始
     *
     */
    case Home_latest(Int)
    
    /**
     *  快讯-列表
     *
     *  @param Int 分页数
     */
    case NewsFlash_latest(Int)
    
    /**
     *  玩物志
     *
     *  @param Int 分页数
     */
    case PlayingZhi_latest(Int)
    
    /**
     *  AppSo
     *
     */
    case AppSo_latest(Int)
    
    /**
     *  MainStore  从0开始
     */
    case MindStore_latest(Int)
    
///    https://www.ifanr.com/api/v3.0/?action=ifr_m_latest&appkey=sg5673g77yk72455af4sd55ea&category_name=video-special&excerpt_length=80&page=1&posts_per_page=12&sign=5a5bc2f2c134026826b92f81e162223c&timestamp=1470050845
    
    /**
     *  分类
     */
    case Category(CategoryName,Int)
    
    /**
     *  获得评论
     */
    case Comments_latest(Int)
}

public enum CategoryName {
    case Video
    case ISeed
    case DaSheng
    case Shudu
    case Evaluation
    case Product
    case Car
    case Business
    case Interview
    case Picture
    case List
    
    func getName() -> String {
        switch self {
        case .Video:
            return "video-special"
        case .ISeed:
            return "iseed"
        case .DaSheng:
            return "dasheng"
        case .Shudu:
            return "data"
        case .Evaluation:
            return "review"
        case .Product:
            return "product"
        case .Car:
            return "intelligentcar"
        case .Business:
            return "business"
        case .Interview:
            return "interview"
        case .Picture:
            return "tuji"
        case .List:
            return "%E6%B8%85%E5%8D%95".stringByRemovingPercentEncoding!
        }
    }
}

extension APIConstant: TargetType {
    //MARK: ---------------------------基本默认要传入的参数 --------------------------
        /// appKey
    private var appKey: String {
        return "sg5673g77yk72455af4sd55ea"
    }
    
    private var excerpt_length: Int {
        return 80
    }
    
    private var sign: String {
        return "be072a0fc0b7020836bae8777f2fbeca"
    }
    
        /// 当前时间的时间戳
    private  var timestamp: String {
        return NSDate.getCurrentTimeStamp()
    }
  
        /// 这个不知什么鬼。首页那里用到
    private var post_type: String {
        switch self {
        case .Home_latest(_), .Home_hot_features(_):
            return "post%2Cnews%2Cdasheng%2Cdata".stringByRemovingPercentEncoding!
        case .NewsFlash_latest(_):
            return "buzz"
        case .PlayingZhi_latest(_):
            return "coolbuy"
        case .AppSo_latest(_):
            return "app"
        case let .Category(type, _):
            return type.getName()
            
        default: return ""
        }
    }
    
    private var action: String {
        switch self {
        case .Home_hot_features(_):
            return "hot_features"
        case .Comments_latest(_):
            return "ifr_m_get_mobile_comments"
        default:
            return "ifr_m_latest"
        }
    }
    
    private var posts_per_page: Int {
        switch self {
        case .Home_hot_features(_):
            return 5
        default:
            return 12
        }
    }
    
    //MARK: --------------------------- Path --------------------------
        /// url
    
    public var baseURL: NSURL {
        switch self {
            /// https://sso.ifanr.com/api/v1.2/mind/?look_back_days=0&limit=60
        case .MindStore_latest(_):
            return NSURL(string: "https://sso.ifanr.com/api/v1.2/mind/")!
        default:
            return NSURL(string: "https://www.ifanr.com/api/v3.0/")!
        }
        
    }
        /// 路径
    public var path: String {
        return ""
    }
        /// 请求方法
    public var method: Moya.Method {
        return .GET
    }
    
        /// 请求参数
    public var parameters: [String: AnyObject]? {
        switch self {
                    /// 首页热门
        case let .Home_hot_features(page):
            return ["action": action, "appKey": appKey, "excerpt_length": excerpt_length, "sign": sign, "timestamp": timestamp, "page": page, "posts_per_page": posts_per_page, "post_type": post_type]
                    /// 首页列表
        case let .Home_latest(page):
            return ["action": action, "appKey": appKey, "excerpt_length": excerpt_length, "sign": sign, "timestamp": timestamp, "page": page, "posts_per_page": posts_per_page, "post_type": post_type]
                    /// 快讯列表
        case let .NewsFlash_latest(page):
            return ["action": action, "appKey": appKey, "excerpt_length": excerpt_length, "sign": sign, "timestamp": timestamp, "page": page, "posts_per_page": posts_per_page, "post_type": post_type]
                    /// 玩物志列表
        case let .PlayingZhi_latest(page):
            return ["action": action, "appKey": appKey, "excerpt_length": excerpt_length, "sign": sign, "timestamp": timestamp, "page": page, "posts_per_page": posts_per_page, "post_type": post_type]
                    /// AppSo
        case let .AppSo_latest(page):
            return ["action": action, "appKey": appKey, "excerpt_length": excerpt_length, "sign": sign, "timestamp": timestamp, "page": page, "posts_per_page": posts_per_page, "post_type": post_type]
                    /// MindStore
        case let .MindStore_latest(page):
            return ["look_back_days": page, "limit": 60]
                    /// 详情页评论
        case .Comments_latest(_):
            return ["action":action, "appKey": appKey, "post_id": "696091","sign": sign, "timestamp": timestamp]
                    /// 分类
        case let .Category(type,page):
            if type == CategoryName.DaSheng || type == CategoryName.Shudu || type == CategoryName.Picture {
                return ["action": action, "appKey": appKey, "excerpt_length": excerpt_length, "sign": sign, "timestamp": timestamp, "page": page, "posts_per_page": posts_per_page, "post_type": post_type]
            } else {
                return ["action": action, "appKey": appKey, "category_name": type.getName(),"excerpt_length": excerpt_length, "sign": sign, "timestamp": timestamp, "page": page, "posts_per_page": posts_per_page, "post_type": post_type]
            }
        }
    }
    
        /// 单元测试用
    public var sampleData: NSData {
        return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}
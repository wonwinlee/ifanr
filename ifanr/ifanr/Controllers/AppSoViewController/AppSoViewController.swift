//
//  AppSoViewController.swift
//  ifanr
//
//  Created by sys on 16/7/7.
//  Copyright © 2016年 ifanrOrg. All rights reserved.
//

import UIKit
import Alamofire

class AppSoViewController: BasePageController {

    var dataSource : Array<AppSoModel> = Array()
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        pullToRefresh.delegate = self
        tableView.sectionHeaderHeight = tableHeaderView.height
        tableView.tableHeaderView = tableHeaderView
        self.getData()
    }
    
    
    func getData() {
        Alamofire.request(.GET, "https://www.ifanr.com/api/v3.0/?action=ifr_m_latest&appkey=sg5673g77yk72455af4sd55ea&excerpt_length=80&page=2&post_type=app&posts_per_page=12&sign=52eb3928dc47f57a26b00932226eff22&timestamp=1467295827", parameters: [:])
            .responseJSON { response in
                
                if let dataAny = response.result.value {
                    
                    let dataDic : NSDictionary = (dataAny as? NSDictionary)!
                    if dataDic["data"] is NSArray {
                        let dataArr : NSArray = (dataDic["data"] as? NSArray)!
                        for item in dataArr {
                            self.dataSource.append(AppSoModel(dict: item as! NSDictionary))
                        }
                    }
                    self.tableView.reloadData()
                }
        }
    }
    //MARK: --------------------------- Getter and Setter --------------------------
     /// 这个属性放到ScrollViewControllerReusable协议， 会初始化两次。所以放到这里好了
    var tableHeaderView: UIView! = {
        return TableHeaderView(model: TableHeaderModelArray[2])
    }()
}

// MARK: - 下拉刷新回调
extension AppSoViewController: PullToRefreshDelegate {
    func pullToRefreshViewWillRefresh(pullToRefreshView: PullToRefreshView) {
        print("将要下拉")
    }
    
    func pullToRefreshViewDidRefresh(pulllToRefreshView: PullToRefreshView) {
//        return ({
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//                NSThread.sleepForTimeInterval(2.0)
//                dispatch_async(dispatch_get_main_queue(), {
//                    pulllToRefreshView.endRefresh()
//                })
//            })
//        })
    }
}


// MARK: - tableView代理和数据源
extension AppSoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        let curModel = self.dataSource[indexPath.row];
        
        debugPrint(curModel.app_icon_url)
        
        if curModel.app_icon_url != "" {
            cell    = AppSoTableViewCell.cellWithTableView(tableView)
            (cell as! AppSoTableViewCell).model = curModel
        } else {
            cell    = PlayingZhiTableViewCell.cellWithTableView(tableView)
            (cell as! PlayingZhiTableViewCell).appSoModel = curModel
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AppSoTableViewCell.estimateCellHeight(self.dataSource[indexPath.row].title!) + 20
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let ifDetailController = IFDetailsController(model: self.dataSource[indexPath.row])
//        self.navigationController?.pushViewController(ifDetailController, animated: true)
    }
}
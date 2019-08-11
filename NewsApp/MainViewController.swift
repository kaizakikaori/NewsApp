//
//  MainViewController.swift
//  NewsApp
//
//  Created by VERTEX21 on 2019/08/11.
//  Copyright © 2019 k-kougi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainViewController: ButtonBarPagerTabStripViewController {
    
    //URLの文字列(yahoo,NHK,週刊文春)
    let urlList: [String] = ["https://news.yahoo.co.jp/pickup/domestic/rss.xml",
                             "https://www.nhk.or.jp/rss/news/cat0.xml",
                             "http://shukan.bunshun.jp/list/feed/rss"]
    
    //タブの名前
    var itemInfo: [IndicatorInfo] = ["Yahoo!", "NHK", "週間文春"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //各VCを返す処理
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var childViewControllers: [UIViewController] = []
        
        for i in 0 ..< urlList.count {
            
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "News") as! NewsViewController
            
            VC.url = urlList[i]
            VC.itemInfo = itemInfo[i]
            childViewControllers.append(VC)

        }
        //VCを返す
        return childViewControllers
    }

}


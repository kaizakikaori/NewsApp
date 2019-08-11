//
//  NewsViewController.swift
//  NewsApp
//
//  Created by VERTEX21 on 2019/08/11.
//  Copyright © 2019 k-kougi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NewsViewController: UIViewController,IndicatorInfoProvider {
    
    // urlを受け取る
    var url: String = ""
    
    //itemInfoを受け取る
    var itemInfo: IndicatorInfo = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
    }
    
}

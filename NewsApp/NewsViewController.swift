//
//  NewsViewController.swift
//  NewsApp
//
//  Created by VERTEX21 on 2019/08/11.
//  Copyright © 2019 k-kougi. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class NewsViewController: UIViewController,IndicatorInfoProvider,UITableViewDataSource,UITableViewDelegate, WKNavigationDelegate,XMLParserDelegate {
    
    var refreshControl: UIRefreshControl!
    
    
    var tableView: UITableView = UITableView()
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    //記事情報の配列の入れ物
    var articles : [Any] = []
    
    //XMLParserインスタンスを取得
    var parser = XMLParser()
    
    // urlを受け取る
    var url: String = ""
    
    //itemInfoを受け取る
    var itemInfo: IndicatorInfo = ""
    
    // XMLファイルに解析をかけた情報
    var elements = NSMutableDictionary()
    // XMLファイルのタグ情報
    var element: String = ""
    // XMLファイルのタイトル情報
    var titleString: String = ""
    // XMLファイルのリンク情報
    var linkString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        //デリゲートとの接続
        tableView.delegate = self
        tableView.dataSource = self
        parser.delegate = self
        webView.navigationDelegate = self
        
        //tableViewmのサイズを確定
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        //tableview
        self.view.addSubview(tableView)
            
        tableView.addSubview(refreshControl)
        
        //最初は隠す
        webView.isHidden = true
        toolBar.isHidden = true
        
        parseUrl()
    }
    @objc func refresh() {
        perform(#selector(delay),with: nil, afterDelay: 2.0)
    }
    @objc func delay() {
        parseUrl()
        refreshControl.endRefreshing()
    }
    
    //urlを解析
    func parseUrl(){
        let urlToSend: URL = URL(string: url)!
        
        parser = XMLParser(contentsOf: urlToSend)!
        //記事情報を初期化
        articles = []
        //
        parser.delegate = self
        // 解析開始
        parser.parse()
        // TableViewのリロード
        tableView.reloadData()
        
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        //elementNameにタグの名前が入ってくるのでelementに代入
        element = elementName
        //エレメントにタイトルが入ってきたら
        if element == "item" {
            //初期化
            elements = [:]
            titleString = ""
            linkString = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element == "title" {
            // stringにタイトルが入っているのでappend
            titleString.append(string)
        } else if element == "link" {
            linkString.append(string)
        }
    }
    // 終了タグを見つけた時
    // 終了タグを見つけた時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // アイテムという要素の中にあるなら、
        if elementName == "item" {
            // titleString,linkStringの中身が空でないなら
            if titleString != "" {
                // elementsに"title"、"Link"というキー値を付与しながらtitleString,linkStringをセット
                elements.setObject(titleString, forKey: "title" as NSCopying)
            }
            if linkString != "" {
                elements.setObject(linkString, forKey: "link" as NSCopying)
            }
            
            // articlesの中にelementsを入れる
            articles.append(elements)
        }
    }
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //記事の数だけセルを返す
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.subtitle,reuseIdentifier: "Call")
        
        //セルの色
        cell.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        print(articles[indexPath.row])
        
        //記事テキストサイズとフォント
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "title") as? String
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.textColor = UIColor.black
        
        //記事urlのサイズとフォント
        cell.detailTextLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "link") as? String
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
    }
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // hhh
        let linkUrl = ((articles[indexPath.row] as AnyObject).value(forKey: "link") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        let urlStr = (linkUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        guard let url = URL(string: urlStr) else{
            return
        }
        let urlRequest = NSURLRequest(url : url)
        webView.load(urlRequest as URLRequest)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        tableView.isHidden = true
        
        toolBar.isHidden = false
        
        webView.isHidden = false
    }
    
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfo
    }
    @IBAction func Cancel(_ sender: Any) {
        tableView.isHidden = false
        webView.isHidden = true
        toolBar.isHidden = true
    }
    @IBAction func backpage(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func nextpage(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func refreshpage(_ sender: Any) {
        webView.reload()
    }
    
    
}

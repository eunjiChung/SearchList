//
//  DetailWebViewController.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit
import WebKit

typealias WebInfo = (title: String, urlString: String)

class DetailWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    var info: WebInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {
        self.title = info?.title
        loadWebPage()
    }

    func loadWebPage() {
        if let urlString = info?.urlString,
           let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    @IBAction func touchBack(_ sender: Any) {
        webView.goBack()
    }

    @IBAction func touchForward(_ sender: Any) {
        webView.goForward()
    }

    @IBAction func touchReload(_ sender: Any) {
        webView.reload()
    }

    @IBAction func touchStop(_ sender: Any) {
        webView.stopLoading()
    }
}

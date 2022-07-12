//
//  WebViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/7/12.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {
    
    private weak var webView: WKWebView!
    
    var viewModel: WebkitModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL()
    }
    
    private func loadURL() {
        guard let viewModel = viewModel,
              let url = URL(string: viewModel.urlString) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
}

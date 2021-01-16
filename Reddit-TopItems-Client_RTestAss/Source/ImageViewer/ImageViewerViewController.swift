//
//  ImageViewerViewController.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 14.01.2021.
//

import UIKit
import WebKit

class ImageViewerViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    static let identifier = "ImageViewerViewController"

    @objc var viewModel: ImageViewerViewModel!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = viewModel?.title {
            navigationItem.title = title
        }
        
        let request = URLRequest(url: viewModel.url)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.startAnimating()
        
        let barButtonItem = UIBarButtonItem(customView: activity)
        navigationItem.setRightBarButton(barButtonItem, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if viewModel?.title == nil {
            navigationItem.title = webView.title
        }
        
        navigationItem.setRightBarButton(nil, animated: true)
    }

}
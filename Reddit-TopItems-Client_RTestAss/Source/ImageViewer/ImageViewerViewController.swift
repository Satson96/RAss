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
    
    static func build() -> ImageViewerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ImageViewerViewController.identifier) as! ImageViewerViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
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

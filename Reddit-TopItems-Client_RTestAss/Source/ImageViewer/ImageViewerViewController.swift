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

    @objc var viewModel: ImageViewerViewModel? {
        didSet {
            if self.isViewLoaded {
                updateViewData()
            }
        }
    }
    
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
        
        updateViewData()
    }
    
    func updateViewData() {
        if let title = viewModel?.title {
            navigationItem.title = title
        }
        
        if let url = viewModel?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
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

// MARK: Overriding UIStateRestoring protocol

extension ImageViewerViewController {
    static var imageViewModelKey = "imageViewerViewModel"

    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(self.viewModel, forKey: ImageViewerViewController.imageViewModelKey)
        super.encodeRestorableState(with: coder)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        self.viewModel = coder.decodeObject(of: ImageViewerViewModel.self,
                                            forKey: ImageViewerViewController.imageViewModelKey)!
        super.decodeRestorableState(with: coder)
    }
}

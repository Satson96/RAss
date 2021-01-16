//
//  RedditItemsViewController.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 11.01.2021.
//

import UIKit

class RedditItemsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self,
                                 action: #selector(refreshTriggered(_:)),
                                 for: .valueChanged)
        
        return refreshControl
    }()
    
    fileprivate var isRefreshPulled = false
    
    let viewModel = RedditItemsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(refreshControl)
        
        viewModel.delegate = self
        viewModel.loadNextPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func toggleNetworkOperation(_ flag: Bool, isRefresh: Bool = false) {
        tableView.isUserInteractionEnabled = !isRefresh
        tableView.alpha = isRefresh ? 0.3 : 1.0
        
        if flag {
            if !isRefresh && viewModel.getNumberOfItems() == 0 {
                // Should show loading indicator only if the list is empty,
                // if there are items in the list, loader should be shown at the end of the list.
                activityIndicatorView.startAnimating()
            }
        } else {
            activityIndicatorView.stopAnimating()
            tableView.tableFooterView = UIView()
            
            refreshControl.endRefreshing()
        }
    }
    
    @objc private func refreshTriggered(_ refreshControl: UIRefreshControl) {
        isRefreshPulled = true
        
        viewModel.refreshPages()
        tableView.reloadData()
    }


}

extension RedditItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditItemTableViewCell.identifier) as! RedditItemTableViewCell
        
        let itemViewModel = viewModel.getViewModel(forIndex: indexPath.row)
        cell.configure(viewModel: itemViewModel)
        
        if let thumbnailImageUrl = itemViewModel.thumbnailSizeImageUrl {
            cell.imageLoadingIndicatorView.startAnimating()
            ImageDownloader.sharedInstance.loadImage(url: thumbnailImageUrl) { (image, url, fromCache) in
                guard let cell = fromCache ? cell : tableView.cellForRow(at: indexPath) as? RedditItemTableViewCell else { return }
                
                if let image = image {
                    cell.itemImageView.image = image
                    cell.imageLoadingIndicatorView.stopAnimating()
                } else {
                    cell.showDefaultImage()
                }
            }
        }
        
        cell.onImagePressed = { [weak itemViewModel, weak self] in
            guard let self = self,
                  let viewModel = itemViewModel else {
                return
            }
            
            guard let webViewModel = viewModel.getImageViewerViewModel() else {
                self.showError(message: "There is no preview image for this post!")
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ImageViewerViewController.identifier) as! ImageViewerViewController
            vc.viewModel = webViewModel
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex
            && indexPath.row == lastRowIndex
            && viewModel.canLoadNextPage() {
            
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0,
                                   width: tableView.bounds.width, height: 44)
            
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            
            viewModel.loadNextPage()
        }
    }
    
}

extension RedditItemsViewController: ViewModelDelegate {
    
    func willLoadData() {
        toggleNetworkOperation(true, isRefresh: isRefreshPulled)
        isRefreshPulled = false
    }
    
    func didLoadData() {
        tableView.reloadData()
        toggleNetworkOperation(false)
    }
    
    func receivedError(message: String) {
        toggleNetworkOperation(false)
        
        showError(message: message)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

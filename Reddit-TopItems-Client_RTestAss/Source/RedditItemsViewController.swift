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
    
    let viewModel = RedditItemsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.loadNextPage()
    }
    
    private func toggleNetworkOperation(_ flag: Bool) {
        if flag {
            if viewModel.getNumberOfItems() == 0 {
                // Should show loading indicator only if the list is empty,
                // if there are items in the list, loader should be shown at the end of the list.
                activityIndicatorView.startAnimating()
            }
        } else {
            activityIndicatorView.stopAnimating()
            tableView.tableFooterView = UIView()
        }
    }


}

extension RedditItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditItemTableViewCell.identifier) as!  RedditItemTableViewCell
        
        cell.configure(viewModel: viewModel.getViewModel(forIndex: indexPath.row))
        
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
        toggleNetworkOperation(true)
    }
    
    func didLoadData() {
        tableView.reloadData()
        toggleNetworkOperation(false)
    }
    
    func receivedError(message: String) {
        toggleNetworkOperation(false)
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

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
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
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

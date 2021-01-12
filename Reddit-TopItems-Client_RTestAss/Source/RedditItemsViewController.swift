//
//  RedditItemsViewController.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 11.01.2021.
//

import UIKit

class RedditItemsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        HTTPNetworkClient.sharedInstance.perform(TopRedditItemsRequest(after: nil, before: nil, limit: nil, count: nil)) { (result: Result<TopRedditItemsResponse, Error>) in
            switch result {
            case .success(let response):
                let items = response.items
                print("items: \(items)")
            case .failure(_):
                break
            }
        }
    }


}

extension RedditItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditItemTableViewCell.identifier) as!  RedditItemTableViewCell
        
        return cell
    }    
    
}


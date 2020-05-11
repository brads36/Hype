//
//  HypeTableViewController.swift
//  Hype
//
//  Created by Bryce Bradshaw on 5/11/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import UIKit

class HypeTableViewController: UITableViewController {
    
    // MARK: - Properties
    var refresh: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadData()
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddHypeAlert()
    }
    
    // MARK: - Class Methods
    func setUpViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to see new Hypes")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc func loadData() {
        HypeController.sharedInstance.fetchAllHypes { (result) in
            switch result {
            case .success(let hypes):
                guard let hypes = hypes else { return }
                HypeController.sharedInstance.hypes = hypes
                self.updateViews()
            case .failure(let error):
                print(error.errorDescription)
                
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    // MARK: - Alert Controller

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return HypeController.sharedInstance.hypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)

        let hype = HypeController.sharedInstance.hypes[indexPath.row]
        cell.textLabel?.text = hype.body
        cell.detailTextLabel?.text = hype.timestamp.formatDate()
        
        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
} // End of Class

extension HypeTableViewController {
    func presentAddHypeAlert() {
        let alertController = UIAlertController(title: "Get Hype!", message: "What is Hype may never die!", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "What is hype today?"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            HypeController.sharedInstance.saveHype(with: text) { (result) in
                switch result {
                case .success(let hype):
                    guard let hype = hype else { return }
                    HypeController.sharedInstance.hypes.insert(hype, at: 0)
                    self.updateViews()
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addHypeAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}

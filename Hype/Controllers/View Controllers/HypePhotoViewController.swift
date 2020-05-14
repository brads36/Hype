//
//  HypePhotoViewController.swift
//  Hype
//
//  Created by Bryce Bradshaw on 5/14/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import UIKit

class HypePhotoViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var hypeTextField: UITextField!
    @IBOutlet weak var photoContainerView: UIView!
    
    // MARK: - Properties
    var image: UIImage?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    @IBAction func confirmButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

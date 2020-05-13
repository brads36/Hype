//
//  SignUpViewController.swift
//  Hype
//
//  Created by Bryce Bradshaw on 5/13/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    // MARK: - Aactions
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Helper Method
    func fetchUser() {
        UserController.sharedInstance.fetchUser { (result) in
            switch result {
            case .success(_):
                <#code#>
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
        guard let username = usernameTextField.text, !username.isEmpty,
            let bio = bioTextField.text else { return }
        UserController.sharedInstance.createUser(username: username, bio: bio) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.presentHypeListVC()
            case .failure(let error):
                print(error)
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    // MARK: - Helper Method
    func fetchUser() {
        UserController.sharedInstance.fetchUser { [weak self] (result) in
            switch result {
            case .success(_):
                self?.presentHypeListVC()
            case .failure(let error):
                print(error)
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }

    func presentHypeListVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HypeList", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
}

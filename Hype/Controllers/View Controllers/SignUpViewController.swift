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
    @IBOutlet weak var photoContainerView: UIView!
    
    // MARK: - Properties
    var profilePhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
            let bio = bioTextField.text else { return }
        UserController.sharedInstance.createUser(username: username, bio: bio, profilePhoto: profilePhoto) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.presentHypeListVC()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    @IBAction func signUpTapGesture(_ sender: Any) {
        hideKeyboard()
    }
    
    // MARK: - Helper Method
    func setupViews() {
        photoContainerView.layer.cornerRadius = photoContainerView.frame.height / 2
        photoContainerView.clipsToBounds = true
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerVC" {
            guard let destinationVC = segue.destination as? PhotoPickerViewController else { return }
            destinationVC.delegate = self
        }
    }
    
} // End of Class

extension SignUpViewController: PhotoPickerDelegate {
    func photoPickerSelected(image: UIImage) {
        self.profilePhoto = image
    }
}

extension SignUpViewController {

    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}

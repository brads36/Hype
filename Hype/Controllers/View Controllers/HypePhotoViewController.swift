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
        self.setupViews()
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView()
    }
    @IBAction func hypePhotoTapGesture(_ sender: Any) {
        hideKeyboard()
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard let text = hypeTextField.text, !text.isEmpty,
            let image = image else { return }
        
        HypeController.sharedInstance.saveHype(with: text, hypePhoto: image) { (result) in
            switch result {
            case .success(_):
                self.dismissView()
                
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods
    func dismissView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func setupViews() {
        photoContainerView.layer.cornerRadius = 20
        photoContainerView.clipsToBounds = true
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerVC" {
            guard let destinationVC = segue.destination as? PhotoPickerViewController else { return }
            destinationVC.delegate = self
        }
    }
}

extension HypePhotoViewController: PhotoPickerDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}

extension HypePhotoViewController {

    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}

//
//  PhotoPickerViewController.swift
//  Hype
//
//  Created by Bryce Bradshaw on 5/14/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import UIKit

protocol PhotoPickerDelegate: class {
    func photoPickerSelected(image: UIImage)
}

class PhotoPickerViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var photoPickerImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    // MARK: - Properties
    var imagePicker = UIImagePickerController()
    weak var delegate: PhotoPickerDelegate?
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openPhotoLibrary()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        present(alertController, animated: true)
    }
    
    // MARK: - Helper Methods
    func setupViews() {
        imagePicker.delegate = self
        photoPickerImageView.backgroundColor = .systemTeal
        photoPickerImageView.contentMode = .scaleAspectFill
        photoPickerImageView.clipsToBounds = true
    }
    
    func presentFailedAlert(title: String, message: String) {
        let failedAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        failedAlert.addAction(okAction)
        self.present(failedAlert, animated: true)
    }
} // End Of Class

extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
        } else {
            self.presentFailedAlert(title: "No Camera Access", message: "Please allow access to the camera to use this feature.")
        }
    }
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        } else {
            self.presentFailedAlert(title: "No Photo Library Access", message: "Please allow access to the Photo library to use this feature.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            guard let delegate = delegate else { return }
            delegate.photoPickerSelected(image: pickedImage)
            photoPickerImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

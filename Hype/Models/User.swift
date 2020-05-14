//
//  User.swift
//  Hype
//
//  Created by Bryce Bradshaw on 5/13/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

struct UserStrings {
    static let recordTypeKey = "User"
    static let usernameKey = "username"
    static let bioKey = "bio"
    static let appleUserReferenceKey = "appleUserReference"
    static let photoAssetKey = "photoAsset"
    
}

class User {
    
    var username: String
    var bio: String
    var profilePhoto: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            self.photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var photoData: Data?
    // CloudKit properties
    var recordID: CKRecord.ID
    var appleUserReference: CKRecord.Reference
    var photoAsset: CKAsset? {
        get {
            guard photoData != nil else { return nil }
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(username: String, bio: String, profilePhoto: UIImage? = nil, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        
        self.username = username
        self.bio = bio
        self.recordID = recordID
        self.appleUserReference = appleUserReference
        self.profilePhoto = profilePhoto
    }
}

extension User {
    convenience init?(ckRecord: CKRecord){
        guard let username = ckRecord[UserStrings.usernameKey] as? String,
            let bio = ckRecord[UserStrings.bioKey] as? String,
            let appleUserReference = ckRecord[UserStrings.appleUserReferenceKey] as? CKRecord.Reference
            else { return nil}
        
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[UserStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        self.init(username: username, bio: bio, profilePhoto: foundPhoto, recordID: ckRecord.recordID, appleUserReference: appleUserReference)
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserStrings.recordTypeKey, recordID: user.recordID)
        setValuesForKeys([
            UserStrings.usernameKey : user.username,
            UserStrings.bioKey : user.bio,
            UserStrings.appleUserReferenceKey : user.appleUserReference,
            UserStrings.photoAssetKey : user.photoAsset
        ])
    }
}

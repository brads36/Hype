//
//  User.swift
//  Hype
//
//  Created by Bryce Bradshaw on 5/13/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import Foundation
import CloudKit

struct UserStrings {
    static let recordTypeKey = "User"
    static let usernameKey = "username"
    static let bioKey = "bio"
    static let appleUserReferenceKey = "appleUserReference"
    
}

class User {
    
    var username: String
    var bio: String
    var recordID: CKRecord.ID
    var appleUserReference: CKRecord.Reference
    
    init(username: String, bio: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        
        self.username = username
        self.bio = bio
        self.recordID = recordID
        self.appleUserReference = appleUserReference
    }
}

extension User {
    convenience init?(ckRecord: CKRecord){
        guard let username = ckRecord[UserStrings.usernameKey] as? String,
            let bio = ckRecord[UserStrings.bioKey] as? String,
            let appleUserReference = ckRecord[UserStrings.appleUserReferenceKey] as? CKRecord.Reference
            else { return nil}
        
        self.init(username: username, bio: bio, recordID: ckRecord.recordID, appleUserReference: appleUserReference)
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserStrings.recordTypeKey, recordID: user.recordID)
        setValuesForKeys([
            UserStrings.usernameKey : user.username,
            UserStrings.bioKey : user.bio,
            UserStrings.appleUserReferenceKey : user.appleUserReference
        ])
    }
}

//
//  UserController.swift
//  Hype
//
//  Created by Bryce Bradshaw on 5/13/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class UserController {
    
    // MARK: - Singleton
    static let sharedInstance = UserController()
    
    // MARK: - Source of Truth
    var currentUser: User?
    
    // MARK: - Database Constant
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    func createUser(username: String, bio: String, profilePhoto: UIImage?, completion: @escaping (Result<Bool, HypeError>) -> Void) {
        
        // Step 4: Fetching the user reference to use it to create a new newUser
        fetchAppleUserReference { [weak self] (reference) in
            guard let reference = reference else { return completion(.failure(.noUserFound))}
            // Step 3: Initialize a newUser with the users reference
            let newUser = User(username: username, bio: bio, profilePhoto: profilePhoto, appleUserReference: reference)
            // Step 2: Create the CKRecord to be saved from the newUser
            let record = CKRecord(user: newUser)
            // Step 1: Call the save method, to save the newly created ckRecord
            self?.publicDB.save(record) { (record, error) in
                // Step 5: Handle Errors
                if let error = error {
                    print(error)
                    print(error.localizedDescription)
                    return completion(.failure(.ckError(error)))
                }
                // Step 6: Unwrap the saved record and init a user from that record
                guard let record = record,
                    let savedUser = User(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
                // Step 7: Set the currentUser to saveUser
                self?.currentUser = savedUser
                // Step 8: Complete True
                completion(.success(true))
            }
        }
    }
    
    func fetchUser(completion: @escaping (Result<Bool, HypeError>)-> Void) {
       // Step 4: Fetch the users appleUserReference for the predicate
        fetchAppleUserReference { [weak self] (reference) in
            guard let reference = reference else { return completion(.failure(.noUserFound))}
            // Step 3: Define the predicate for the query
            let predicate = NSPredicate(format: "%k == %@", argumentArray: [UserStrings.appleUserReferenceKey, reference])
            // Step 2: Define Query to be performed
            let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
            // Step 1: Call perform method, perform Query
            self?.publicDB.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                // Step 5: Handle errors
                if let error = error {
                    print(error)
                    print(error.localizedDescription)
                    return completion(.failure(.ckError(error)))
                }
                // Step 6: get the first record from the returned records, and unwrap it. Then create User from that record
                guard let record = records?.first,
                let fetchedUser = User(ckRecord: record)
                    else { return completion(.failure(.couldNotUnwrap))}
                // Step 7: Set the currentUser (source of truth) to the fetchedUser
                self?.currentUser = fetchedUser
                // Step 8: Complete
                completion(.success(true))
            })
        }
        
    }
    
    func updateUser(user: User) {
        
    }
    
    func deleteUser(user: User) {
        
    }
    
    // MARK: - Helper Methods
    private func fetchAppleUserReference(completion: @escaping (CKRecord.Reference?)-> Void) {
        // Step 1: Access Users CKContainer and feth ther recordID
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            // Step 2: Handle Errors
            if let error = error {
                print(error)
                print(error.localizedDescription)
                return completion(nil)
            }
            // Step 3: Unwrap the returned recordID
            guard let recordID = recordID else { return completion(nil)}
            // Step 4: Create a CKRecord.Reference using the unwrapped recordID
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            // Step 5: Complete with the reference
            completion(reference)
        }
        
    }
    
} // End Of Class

//
//  HypeController.swift
//  Hype
//
//  Created by Bryce Bradshaw on 5/11/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class HypeController {
    
    // MARK: - Singleton
    static let sharedInstance = HypeController()
    
    // MARK: - Source Of Truth
    var hypes: [Hype] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    // MARK: - CRUD
    func saveHype(with text: String, hypePhoto: UIImage ,completion: @escaping (Result<Hype?, HypeError>) -> Void)  {
       
        guard let currentUser = UserController.sharedInstance.currentUser else { return completion(.failure(.noUserFound))}
        
        let reference = CKRecord.Reference(recordID: currentUser.recordID, action: .none)
        let newHype = Hype(body: text, hypePhoto: hypePhoto ,userReference: reference)
        let hypeRecord = CKRecord(hype: newHype)
        publicDB.save(hypeRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
            let savedHype = Hype(ckRecord: record)
                else { return completion(.failure(.couldNotUnwrap))}
            print("Saved Hype successfully")
            completion(.success(savedHype))
        }
    }
    
    func fetchAllHypes(completion: @escaping (Result<[Hype]?, HypeError>) -> Void) {
        
        
        let fetchAllHypesPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: fetchAllHypesPredicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            
            print("Fetched all hypes successfully.")
            let hypes = records.compactMap({ Hype(ckRecord: $0) })
            completion(.success(hypes))
        }
    }
    
    func update(_ hype: Hype, completion: @escaping (Result<Hype?, HypeError>) ->Void)  {
        guard hype.userReference?.recordID == UserController.sharedInstance.currentUser?.recordID else { return completion(.failure(.unableToEdit))}
        // Step 3: Create the record to save(update)
        let record = CKRecord(hype: hype)
        
        // Step 2: Create our operation
        let operation = CKModifyRecordsOperation(recordsToSave: [record])
        // Step 4: Set the properies of the operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {(records, _, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first,
            let updatedHype = Hype(ckRecord: record)
                else { return completion(.failure(.couldNotUnwrap))}
            print("Updated \(record.recordID) successfully in cloudkit")
            completion(.success(updatedHype))
        }
        // Step 1: add operation to the database
        publicDB.add(operation)
    }
    
    func delete(_ hype: Hype, completion: @escaping (Result<Bool, HypeError>) -> Void) {
        // Step 2: Create our operation
        let operation = CKModifyRecordsOperation(recordIDsToDelete: [hype.recordID])
        // Step 3: set properties of Operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {(records, _, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            if records?.count == 0 {
                print("Successfully deleted record from cloudkit")
                completion(.success(true))
            } else {
                return completion(.failure(.unexpectedRecordsFound))
            }
        }
        // Step 1: add operation to the database
        publicDB.add(operation)
    }
    
    // MARK: - Subscription Method
    func subscribeToRemoteNotifications(completion: @escaping (Error?) -> Void) {
        
        let hypeSubPredicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: HypeStrings.recordTypeKey, predicate: hypeSubPredicate, options: [.firesOnRecordCreation, .firesOnRecordUpdate])
        let notificationInfo = CKQuerySubscription.NotificationInfo()
        notificationInfo.title = "CHOO CHOO"
        notificationInfo.alertBody = "Can't Stop the Hype Train!!"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo
            
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
}

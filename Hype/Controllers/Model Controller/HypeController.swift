//
//  HypeController.swift
//  Hype
//
//  Created by Bryce Bradshaw on 5/11/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import Foundation
import CloudKit

class HypeController {
    
    // MARK: - Singleton
    static let sharedInstance = HypeController()
    
    // MARK: - Source Of Truth
    var hypes: [Hype] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    // MARK: - CRUD
    func saveHype(with text: String, completion: @escaping (Result<Hype?, HypeError>) -> Void)  {
        let newHype = Hype(body: text)
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
}

//
//  HypeError.swift
//  Hype
//
//  Created by Bryce Bradshaw on 5/11/20.
//  Copyright © 2020 Bryce Bradshaw. All rights reserved.
//

import Foundation

enum HypeError: LocalizedError {
    
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get this Hype... Which is not very hype..."
            
        }
    }
}
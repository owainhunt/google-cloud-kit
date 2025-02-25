//
//  SecretManagerScope.swift
//  
//
//  Created by Andrew Edwards on 8/20/22.
//

import Core
import Foundation

public enum GoogleCloudSecretManagerScope: GoogleCloudAPIScope, CaseIterable {
    /// See, edit, configure, and delete your Google Cloud data and see the email address for your Google Account.
    case cloudPlatform
    
    public var value: String {
        switch self {
            case .cloudPlatform: return "https://www.googleapis.com/auth/cloud-platform"
        }
    }
}

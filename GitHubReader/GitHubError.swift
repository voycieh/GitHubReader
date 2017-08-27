//
//  GitHubErrorMessage.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 27/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import Foundation

class GitHubError {
    
    var message: String
    var documentationUrl: String?
    
    init(data: [String: Any]) {
        self.message = data["message"] as! String
        self.documentationUrl = data["documentation_url"] as? String
    }
    
}

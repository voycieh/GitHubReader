//
//  GitHybRepositories.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 19/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import Foundation

class GitHubRepository: CustomStringConvertible {
    var name: String = ""
    var repDescription: String?
    var avatarUrl: String?
    
    init(data: [String: Any]) {
        self.name = data["name"] as! String
        if let des = data["description"] as? String {
            self.repDescription = des
        }
        
        if let owner = data["owner"] as? [String: Any],
            let url = owner["avatar_url"] as? String {
            self.avatarUrl = url
        }
    }
    
    var description: String {
        return "GitHubRepository: \"\(name)\", description=\"\(String(describing: repDescription))\""
    }
}

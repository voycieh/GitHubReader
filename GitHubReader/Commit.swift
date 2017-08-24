//
//  Commit.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 24/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import Foundation

class Commit {
    
    var sha: String
    var authorName: String?
    var authorEmail: String?
    var date: Date?
    var message: String?
    
    init(data: [String: Any], dateFormatter: DateFormatter) {
        self.sha = data["sha"] as! String
        
        if let commit = data["commit"] as? [String: Any] {
            self.message = commit["message"] as? String
            
            if let author = commit["author"] as? [String: Any] {
                self.authorName = author["name"] as? String
                self.authorEmail = author["email"] as? String
                if let date = author["date"] as? String {
                    self.date = dateFormatter.date(from: date)
                }
            }
        }
        
    }
    
}

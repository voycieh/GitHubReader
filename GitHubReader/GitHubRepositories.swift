//
//  GitHybRepositories.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 19/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import Foundation

class GitHubRepoOwner: CustomStringConvertible, Codable {
    var avatarUrl: String?
    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
    
    var description: String {
        return "GitHubRepOwner: \"\(String(describing: avatarUrl))\""
    }
}

class GitHubRepository: CustomStringConvertible, Codable {
    var name: String = ""
    var repDescription: String?
//    var owner: GitHubRepoOwner?
    var updatedAt: Date?
    var avatarUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, repDescription = "description", updatedAt = "updated_at", owner
    }
    
    private enum OwnerKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let owner = try values.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        self.name = try values.decode(String.self, forKey: .name)
        self.repDescription = try values.decodeIfPresent(String.self, forKey: .repDescription)
        self.avatarUrl = try owner.decodeIfPresent(String.self, forKey: .avatarUrl)
        self.updatedAt = try values.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var owner = container.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        try owner.encode(self.avatarUrl, forKey: .avatarUrl)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.repDescription, forKey: .repDescription)
        try container.encode(self.updatedAt, forKey: .updatedAt)
    }
    
//    init(data: [String: Any]) {
//        self.name = data["name"] as! String
//        if let des = data["description"] as? String {
//            self.repDescription = des
//        }
//
//        if let owner = data["owner"] as? [String: Any],
//            let url = owner["avatar_url"] as? String {
//            self.avatarUrl = url
//        }
//    }
    
    var description: String {
        return "GitHubRepository: \"\(name)\", description=\"\(String(describing: repDescription))\""
    }
    
    
}


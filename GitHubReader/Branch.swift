//
//  Branch.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 27/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import Foundation

class Branch: CustomStringConvertible {
    
    var name: String
    
    init(data: [String: Any]) {
        self.name = data["name"] as! String
    }
    
    var description: String {
        return "Branch: \(self.name)"
    }
    
}

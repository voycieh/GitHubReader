//
//  String+Extensions.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 20/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import Foundation

extension String {
    
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        
        return nil
    }
    
}

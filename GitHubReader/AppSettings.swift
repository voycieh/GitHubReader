//
//  AppSettings.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 20/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import Foundation

fileprivate let githubUserKey = "GitHubUserKey"
fileprivate let pageSizeKey = "PageSizeKey"

class AppSettings {
 
    static var shared = AppSettings()
    private init() { load() }
    
    var githubUser: String = "apple"
    var pageSize: Int = 20
    
    fileprivate func load() {
        let defaults = UserDefaults.standard
        self.githubUser = defaults.string(forKey: githubUserKey) ?? "apple"
        self.pageSize = defaults.integer(forKey: pageSizeKey)
        if self.pageSize == 0 {
            self.pageSize = 20
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(githubUser, forKey: githubUserKey)
        defaults.set(pageSize, forKey: pageSizeKey)
        defaults.synchronize()
    }

    
}

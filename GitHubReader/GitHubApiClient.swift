//
//  GitHubApiClient.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 19/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import Foundation
import Alamofire
import UIKit.UIImage

enum ApiError: Error {
    
    case unexpectedResponse(response: String?)
    
}

class GitHubApiClient {
    
    private(set) var baseUrl: String
    var pageSize: Int
    
    fileprivate var loadedPages: [Int] = []
    
    init(baseUrl: String, pageSize: Int) {
        self.baseUrl = baseUrl
        self.pageSize = pageSize
    }
    
    func clearPagesCache() {
        loadedPages = []
    }
    
    func repositories(for user: String, page: Int, completionHandler: @escaping ([GitHubRepository]) -> Void, failureHandler: @escaping (Error) -> Void) {
        if loadedPages.contains(page) { return }
        
        guard let url = URL(string: baseUrl + "users/\(user)/repos?per_page=\(pageSize)&page=\(page)") else { return }
        loadedPages.append(page)
        
        var request = URLRequest(url: url)
        if let base64 = "voycieh:a12345678".base64Encoded() {
            request.addValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        }
        Alamofire.request(request).responseJSON { (response) in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                if json is Array<Any> {
                    let repositories = (json as! [[String: Any]]).map { GitHubRepository(data: $0) }
                    completionHandler(repositories)
                } else {
                    let er = ApiError.unexpectedResponse(response: String(data: response.data!, encoding: .utf8))
                    failureHandler(er)
                }
            }
        }
    }

    static func downloadImage(url: String, completionHandler: @escaping (UIImage) -> Void) {
        guard let ur = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: ur) { (data, response, error) in
            guard error == nil else {
                print(String(describing: error))
                return
            }
            
            guard let data = data else {
                print("EMPTY DATA")
                return
            }
            
            if let image = UIImage(data: data) {
                completionHandler(image)
            }
        }
        
        task.resume()
    }
}

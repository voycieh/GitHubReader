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
        
        let request = self.prepareUrlRequest(url: url)
        Alamofire.request(request).responseJSON { (response) in
            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
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
    
    func commits(for user: String, repositoryName: String, branchName: String? = nil, completionHandler: @escaping ([Commit]) -> Void, failureHandler: @escaping (Error) -> Void) {
        var urlPath = "repos/\(user)/\(repositoryName)/commits"
        if let branch = branchName {
            urlPath += "?sha=\(branch)"
        }
        
        guard let url = URL(string: baseUrl + urlPath) else { return }
        let request = self.prepareUrlRequest(url: url)
        Alamofire.request(request).responseJSON { (response) in
            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
                if json is Array<Any> {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    
                    let commits = (json as! [[String: Any]]).map { Commit(data: $0, dateFormatter: dateFormatter) }
                    completionHandler(commits)
                } else {
                    let er = ApiError.unexpectedResponse(response: String(data: response.data!, encoding: .utf8))
                    failureHandler(er)
                }
            }
        }

    }
    
    func branches(for user: String, repositoryName: String, completionHandler: @escaping ([Branch]) -> Void, failureHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: baseUrl + "repos/\(user)/\(repositoryName)/branches") else { return }
        let request = self.prepareUrlRequest(url: url)
        Alamofire.request(request).responseJSON { (response) in
            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
                if json is Array<Any> {
                    let branches = (json as! [[String: Any]]).map { Branch(data: $0) }
                    completionHandler(branches)
                } else {
                    let er = ApiError.unexpectedResponse(response: String(data: response.data!, encoding: .utf8))
                    failureHandler(er)
                }
            }
        }
        
    }
    
    private func prepareUrlRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        if let base64 = "voycieh:a12345678".base64Encoded() {
            request.addValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        }
        return request
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

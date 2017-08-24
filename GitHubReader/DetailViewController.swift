//
//  DetailViewController.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 19/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var repository: GitHubRepository?
    var apiClient: GitHubApiClient?
    
    var commits: [Commit] = []
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = self.repository?.name
        self.descriptionLabel.text = self.repository?.repDescription
        
        self.title = self.repository?.name
        self.navigationController?.isNavigationBarHidden = false
        
        guard let repositoryName = self.repository?.name else { return }
        self.apiClient?.commits(for: AppSettings.shared.githubUser, repositoryName: repositoryName, completionHandler: { (commits) in
            self.commits = commits
            print(commits)
        }, failureHandler: { (error) in
            print(String(describing: error))
        })
        
        guard let avatarUrl = self.repository?.avatarUrl else { return }
        GitHubApiClient.downloadImage(url: avatarUrl) { [weak self] (image) in
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

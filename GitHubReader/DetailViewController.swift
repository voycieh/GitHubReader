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
    var branches: [Branch] = []
    var selectedBranch: Branch? {
        didSet {
            self.branchButton.setTitle(selectedBranch?.name ?? "", for: .normal)
        }
    }
    let authorStringAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)]
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commit: UITableView!
    @IBOutlet weak var branchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = self.repository?.name
        self.descriptionLabel.text = self.repository?.repDescription
        
        self.title = self.repository?.name
        self.navigationController?.isNavigationBarHidden = false
        
        self.getBranches()
        
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
    
    func failure(error: Error) {
        print(String(describing: error))
    }
    
    private func getBranches() {
        guard let repositoryName = self.repository?.name else { return }
        self.apiClient?.branches(for: AppSettings.shared.githubUser, repositoryName: repositoryName, completionHandler: { (branches) in
            self.branches = branches
            if let branch = branches.first {
                self.selectedBranch = branch
                self.commits(for: branch)
            }
        }, failureHandler: self.failure)
    }
    
    fileprivate func commits(for branch: Branch) {
        guard let repositoryName = self.repository?.name else { return }
        print(branch)
        self.apiClient?.commits(for: AppSettings.shared.githubUser, repositoryName: repositoryName, branchName: branch.name, completionHandler: { (commits) in
            self.commits = commits
            self.commit.reloadData()
//            print(commits)
        }, failureHandler: self.failure)
    }
    
    @IBAction func branchButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "BranchSegue", sender: sender)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BranchListViewController {
            let ctrl = segue.destination as! BranchListViewController
            ctrl.branches = self.branches
            ctrl.selectedBranch = self.selectedBranch
            ctrl.listDelegate = self
        }
    }
    

}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commits.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommitCell", for: indexPath) as! CommitCell
        let commit = self.commits[indexPath.row]
        cell.shaLabel.text = commit.sha
        
        guard let authorName = commit.authorName, let authorEmail = commit.authorEmail else { return cell }
        let authorString = NSMutableAttributedString(string: "\(authorName) \(authorEmail)")
        let nameRange = NSRange(location: 0, length: authorName.characters.count)
        authorString.addAttributes(self.authorStringAttributes, range: nameRange)
        cell.authorLabel.attributedText = authorString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        if let date = commit.date {
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        cell.messageLabel.text = commit.message ?? ""
        //commit.message != nil ? commit.message! : ""
        
        
        return cell
    }

}

extension DetailViewController: BranchListDelegate {
    func didSelect(branch: Branch) {
        self.selectedBranch = branch
        self.commits(for: self.selectedBranch!)
    }
}


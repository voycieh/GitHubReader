//
//  ViewController.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 19/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let apiClient = GitHubApiClient(baseUrl: "https://api.github.com/", pageSize: AppSettings.shared.pageSize)
    var elementyTablicy: Array<GitHubRepository> = []
    var widoczneElementyTablicy: Array<GitHubRepository> {
        guard let text = self.searchBar.text?.lowercased() else { return elementyTablicy }
        guard text.characters.count > 0 else { return elementyTablicy }
        
        return self.elementyTablicy.filter { repo -> Bool in
            var search = repo.name
            if let descr = repo.repDescription {
                search += descr
            }
            return search.lowercased().contains(text)
        }
    }
    
    var currentPage = 1
    fileprivate var canLoadMore = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.callForData(page: self.currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiClient.pageSize = AppSettings.shared.pageSize
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailViewController {
            guard let cell = sender as? UITableViewCell,
                let indexPath = self.tableView.indexPath(for: cell)
                else { return }
            let ctrl = segue.destination as! DetailViewController
            ctrl.repository = self.elementyTablicy[indexPath.row]
            ctrl.apiClient = self.apiClient
        }
        
        if segue.destination is CreateRepositoryViewController {
            let ctrl = segue.destination as! CreateRepositoryViewController
            ctrl.apiClient = self.apiClient
        }
    }
    
    fileprivate func callForData(page: Int) {
        guard self.canLoadMore else { return }
        
        self.apiClient.repositories(for: AppSettings.shared.githubUser, page: page, completionHandler: { [weak self] repositories in
            self?.elementyTablicy.append(contentsOf: repositories)
            self?.currentPage = page
            self?.canLoadMore = repositories.count >= AppSettings.shared.pageSize
            print("Loaded page \(page) with \(repositories.count) new repositories.")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.title = AppSettings.shared.githubUser
            }
            }, failureHandler: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
        })
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        self.currentPage = 1
        self.apiClient.clearPagesCache()
        self.elementyTablicy = []
        self.canLoadMore = true
        self.callForData(page: self.currentPage)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.widoczneElementyTablicy.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.widoczneElementyTablicy[indexPath.row].name
        cell.detailTextLabel?.text = self.widoczneElementyTablicy[indexPath.row].repDescription
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if Double(indexPath.row) > Double(self.widoczneElementyTablicy.count) * 0.7 {
            self.callForData(page: self.currentPage + 1)
        }
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}

//
//  CreateRepositoryViewController.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 27/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import UIKit

class CreateRepositoryViewController: UIViewController {

    var apiClient: GitHubApiClient?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var privateSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction(_:)))
        self.title = NSLocalizedString("Create", comment: "Create repository constroller title")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveAction(_ sender: UIBarButtonItem) {
        guard let name = self.nameTextField.text else { return }
        guard name.characters.count > 0 else { return }
        self.apiClient?.createRepository(name: name, description: self.descriptionTextView.text, isPrivate: self.privateSwitch.isOn, completionHandler: { (repository) in
            print(repository)
        }, failureHandler: { (error) in
            if error is ApiError {
                let er = error as! ApiError
                switch er {
                case .githubError(let error):
                    let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                default: print(er)
                }
            }
        })
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

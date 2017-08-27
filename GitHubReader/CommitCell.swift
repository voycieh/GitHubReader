//
//  CommitCell.swift
//  GitHubReader
//
//  Created by Wojciech Pelc on 24/08/2017.
//  Copyright © 2017 Wojciech Pelc. All rights reserved.
//

import UIKit

class CommitCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var shaLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

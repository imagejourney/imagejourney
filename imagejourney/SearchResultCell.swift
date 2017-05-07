//
//  SearchResultCell.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 5/7/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var journalAuthorLabel: UILabel!
    
    var journal: Journal! {
        didSet {
            journalTitleLabel.text = journal.title
            journalAuthorLabel.text = "by \(journal.author?.name ?? "anonymous")"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

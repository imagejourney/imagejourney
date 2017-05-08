//
//  JournalCell.swift
//  imagejourney
//
//  Created by Sophia on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import AFNetworking
import UIKit

class JournalCell: UITableViewCell {

    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var previewImageOne: UIImageView!
    @IBOutlet weak var previewImageTwo: UIImageView!
    @IBOutlet weak var previewImageThree: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buildCellWithJournal(journal: Journal) {
        tripTitleLabel.text = journal.title
        authorName.text = "by \(journal.author?.name ?? "anonymous")"
        if journal.previewImageUrls == nil || (journal.previewImageUrls?.count)! == 0 {
            previewImageOne.image = #imageLiteral(resourceName: "preview_image_placeholder")
            previewImageTwo.image = #imageLiteral(resourceName: "preview_image_placeholder")
            previewImageThree.image = #imageLiteral(resourceName: "preview_image_placeholder")
        } else {
            previewImageOne.setImageWith((journal.previewImageUrls?[0])!)
            previewImageTwo.setImageWith((journal.previewImageUrls?[1])!)
            previewImageThree.setImageWith((journal.previewImageUrls?[2])!)
        }
    }

}

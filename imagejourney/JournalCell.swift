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
        if journal.previewImages == nil || (journal.previewImages?.count)! == 0 {
            previewImageOne.image = #imageLiteral(resourceName: "preview_image_placeholder")
            previewImageTwo.image = #imageLiteral(resourceName: "preview_image_placeholder")
            previewImageThree.image = #imageLiteral(resourceName: "preview_image_placeholder")
        } else {
            previewImageOne.image = journal.previewImages?[0]
            if((journal.previewImages?.count)! > 0){
                previewImageTwo.image = journal.previewImages?[1]
            }else{
                previewImageTwo.image = #imageLiteral(resourceName: "preview_image_placeholder")
            }
            if((journal.previewImages?.count)! > 1){
                previewImageThree.image = journal.previewImages?[2]
            }else{
                previewImageThree.image = #imageLiteral(resourceName: "preview_image_placeholder")
            }
        }
    }
}

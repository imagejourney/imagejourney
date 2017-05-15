//
//  ImageCollectionViewCell.swift
//  imagejourney
//
//  Created by James Man on 5/14/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var defaultImageView: UIImageView!
    @IBOutlet var selectedImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultImageView.image = UIImage(named: "camera")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        defaultImageView.tintColor = Constants.THEME_COLOR
        // Initialization code
    }
}

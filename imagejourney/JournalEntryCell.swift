//
//  JournalEntryCell.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class JournalEntryCell: UITableViewCell {

    @IBOutlet weak var entryTimeLabel: UILabel!
    @IBOutlet weak var entryLocationLabel: UILabel!
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var topMapLine: UIView!
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var bottomMapLine: UIView!
    @IBOutlet weak var mapCircle: UIImageView!
    
    var segmentPositionTuple: (Int, Int)!
    
    var totalCellsInTable: Int! = 0
    
    var entry: JournalEntry! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d yyyy, h:mm a"
            if let date = entry.date {
                entryTimeLabel.text = dateFormatter.string(from: date)
            }
            
            let weatherTypeString: String = entry.weather!
            switch weatherTypeString {
            case "Cloudy":
                weatherIconView.image = UIImage(named: "clouds")
            case "Rainy":
                weatherIconView.image = UIImage(named: "rain-1")
            case "Snowy":
                weatherIconView.image = UIImage(named: "snow-1")
            case "Stormy":
                weatherIconView.image = UIImage(named: "storm")
            case "Windy":
                weatherIconView.image = UIImage(named: "wind")
            default:
                weatherIconView.image = UIImage(named: "sun-1")
            }
            Helper.getLocationString(location: entry.location!, handler: {(locationString) -> Void in
                self.entryLocationLabel.text = locationString
            })
            if (entry.images?.isEmpty)! {
               entryImageView.image = #imageLiteral(resourceName: "preview_image_placeholder")
            } else{
               entryImageView.image = entry.images?[0]
            }
            entryDescriptionLabel.text = entry.desc
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mapPin.tintColor = Helper.UIColorFromHex(rgbValue: 0x37474f)
        mapCircle.tintColor = Helper.UIColorFromHex(rgbValue: 0x37474f)
    }
    
    override func layoutSubviews() {
        bottomMapLine.setNeedsLayout()
        bottomMapLine.layoutIfNeeded()
        if segmentPositionTuple.0 == 0 {
            topMapLine.isHidden = true
        } else {
            topMapLine.isHidden = false
        }
        
        if segmentPositionTuple.0 == segmentPositionTuple.1-1 {
            bottomMapLine.isHidden = true
        } else {
            bottomMapLine.isHidden = false
        }
        
        let segmentColors = Helper.getMapSegmentColors(color1: Constants.MAPLINE_BLUE, color2: Constants.MAPLINE_GREEN, segmentIndex: segmentPositionTuple.0, totalSegments: segmentPositionTuple.1)
        
        let gradient = CAGradientLayer()
        let gradient2 = CAGradientLayer()
        
        if let sublayers = topMapLine.layer.sublayers {
            if sublayers.count > 0 {
                topMapLine.layer.sublayers = nil
                bottomMapLine.layer.sublayers = nil
            }
        }
        
        gradient.frame = topMapLine.bounds
        gradient.colors = [segmentColors.0.cgColor, segmentColors.0.cgColor]
        gradient.locations = [0.0, 1.0]
        
        gradient2.frame = bottomMapLine.bounds
        print("\(segmentPositionTuple.0), \(segmentPositionTuple.1)")
        print("bottom map line bounds: \(bottomMapLine.bounds)")
        gradient2.colors = [segmentColors.0.cgColor, segmentColors.1.cgColor]
        gradient2.locations = [0.0, 1.0]
        
        topMapLine.layer.insertSublayer(gradient, at: 0)
        bottomMapLine.layer.insertSublayer(gradient2, at: 0)
        
        //            //dotted line for top segment
        //            let shapeLayer: CAShapeLayer = CAShapeLayer()
        //
        //            shapeLayer.name = "DashedTopLine"
        //            shapeLayer.frame = topMapLine.bounds
        //            shapeLayer.strokeColor = UIColor.orange.cgColor
        //            shapeLayer.lineWidth = 5
        //            shapeLayer.lineCap = kCALineJoinRound
        //            shapeLayer.lineDashPattern = [2, 20]
        //
        //            let path: CGMutablePath = CGMutablePath()
        //            path.move(to: CGPoint(x: topMapLine.bounds.origin.x + topMapLine.bounds.width / 2, y: topMapLine.bounds.origin.y))
        //            path.addLine(to: CGPoint(x: topMapLine.bounds.origin.x + topMapLine.bounds.width / 2, y: topMapLine.bounds.origin.y + topMapLine.bounds.height))
        //            shapeLayer.path = path
        //
        //            gradient.mask = shapeLayer
        //
        //            //dotted line for bottom segment
        //            let shapeLayer2: CAShapeLayer = CAShapeLayer()
        //
        //            shapeLayer2.name = "DashedTopLine"
        //            shapeLayer2.frame = bottomMapLine.bounds
        //            shapeLayer2.strokeColor = UIColor.orange.cgColor
        //            shapeLayer2.lineWidth = 5
        //            shapeLayer2.lineCap = kCALineJoinRound
        //            shapeLayer2.lineDashPattern = [2, 20]
        //
        //            let path2: CGMutablePath = CGMutablePath()
        //            path2.move(to: CGPoint(x: bottomMapLine.bounds.origin.x + bottomMapLine.bounds.width / 2, y: bottomMapLine.bounds.origin.y))
        //            path2.addLine(to: CGPoint(x: bottomMapLine.bounds.origin.x + bottomMapLine.bounds.width / 2, y: bottomMapLine.bounds.origin.y + bottomMapLine.bounds.height))
        //            shapeLayer2.path = path2
        //
        //            gradient2.mask = shapeLayer2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

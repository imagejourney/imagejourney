//
//  JournalEntryViewController.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class JournalEntryViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    
    var entry: JournalEntry! {
        didSet{
            self.loadViewIfNeeded()// should be view.layoutIfNeeded?
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d yyyy, h:mm a"
            if let date = entry.date {
                dateLabel.text = dateFormatter.string(from: date)
            }
            
            let weatherTypeString: String = entry.weather!
            switch weatherTypeString {
            case "Cloudy":
                weatherIconView.image = UIImage(named: "cloud")
            case "Rainy":
                weatherIconView.image = UIImage(named: "rain")
            case "Snowy":
                weatherIconView.image = UIImage(named: "snow")
            case "Flashy":
                weatherIconView.image = UIImage(named: "flash")
            default:
                weatherIconView.image = UIImage(named: "sun")
            }
            JournalEntry.getLocationString(location: entry.location!, handler: {(locationString) -> Void in
                self.locationLabel.text = locationString
            })
            if (entry.images?.isEmpty)!{
                imageView.image = #imageLiteral(resourceName: "preview_image_placeholder")
            } else {
                imageView.image = entry.images?[0]
            }
            descLabel.text = entry.desc
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

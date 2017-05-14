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
                weatherIconView.image = UIImage(named: "cloudy-icon")
            case "Rain":
                weatherIconView.image = UIImage(named: "rain-icon")
            case "Snow":
                weatherIconView.image = UIImage(named: "snow-icon")
            default:
                weatherIconView.image = UIImage(named: "sunny-icon")
            }
//            locationLabel.text = entry.location
            imageView.image = entry.image
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

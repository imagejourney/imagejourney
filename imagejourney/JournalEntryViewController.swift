//
//  JournalEntryViewController.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit
import ImageSlideshow

class JournalEntryViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    
    @IBOutlet var imageSlides: ImageSlideshow!
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
            descLabel.text = entry.desc
            var sources:[ImageSource]? = []
            for image in entry.images! {
                sources?.append(ImageSource(image: image))
            }
            imageSlides.setImageInputs(sources!)
            imageSlides.backgroundColor = Constants.THEME_COLOR_TWO
            imageSlides.slideshowInterval = 3.0
            imageSlides.pageControlPosition = PageControlPosition.underScrollView
            imageSlides.pageControl.currentPageIndicatorTintColor = UIColor.gray
            imageSlides.pageControl.pageIndicatorTintColor = Constants.THEME_COLOR
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnSlides))
            imageSlides.addGestureRecognizer(recognizer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    func didTapOnSlides(){
        imageSlides.presentFullScreenController(from: self)
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

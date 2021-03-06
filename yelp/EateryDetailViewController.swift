//
//  EateryDetailViewController.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/24/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit
import MapKit

class EateryDetailViewController: UIViewController {
  
  @IBOutlet var paperView: UIView!
  @IBOutlet var previewImageView: UIImageView!
  @IBOutlet var infoView: UIView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var phoneLabel: UILabel!
  @IBOutlet var addressLabel: UILabel!
  @IBOutlet var ratingLabel: UILabel!
  @IBOutlet var ratingStarsView: UIView!
  @IBOutlet var reviewCountLabel: UILabel!
  
  @IBOutlet var mapView: MKMapView!
  
  var eatery: Eatery!
  var eateryLocation: CLLocation!
  var eateryPin: EateryPin!
  let regionRadius: CLLocationDistance = 700
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    paperView.layer.shadowOffset = CGSize(width: 0, height: 1)
    paperView.layer.shadowOpacity = 0.25
    paperView.layer.shadowRadius = 2
    
    infoView.layoutMargins = Margins.large
    
    nameLabel.textColor = Colors.text
    addressLabel.textColor = Colors.text
    reviewCountLabel.textColor = Colors.lightText
    ratingStarsView.backgroundColor = UIColor.clearColor()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    title = eatery?.name
    
    nameLabel.text = eatery?.name
    phoneLabel.text = eatery?.phone
    addressLabel.text = eatery?.address
    
    if let rating = eatery?.rating {
      ratingLabel.text = String(format: "%.1f", arguments: [rating])
    }
    
    if let reviewCount = eatery?.reviewCount {
      reviewCountLabel.text = String(format: "%d reviews", arguments: [reviewCount])
    }
    
    if let imageURLString = eatery?.imageURLString {
      previewImageView.clipsToBounds = true
      previewImageView.contentMode = .ScaleAspectFill
      previewImageView.af_setImageWithURL(NSURL(string: imageURLString)!, imageTransition: .CrossDissolve(0.2))
    }
    
    ratingStarsView.subviews.forEach { starView in
      starView.removeFromSuperview()
    }
    
    var rating: Float = 0
    
    if let r = eatery?.rating {
      rating = r
    }
    
    for i in 1...5 {
      var imageName = "star-none"
      
      if rating >= Float(i) {
        imageName = "star-full"
        
      } else if rating > Float(i - 1) {
        imageName = "star-half"
      }
      
      let imageView = UIImageView(image: UIImage(named: imageName))
      imageView.frame = CGRectMake(CGFloat((i - 1) * 12), 0, 10, 10)
      
      ratingStarsView.addSubview(imageView)
    }
    
    eateryLocation = CLLocation(
      latitude: Double(eatery.latitude),
      longitude: Double(eatery.longitude)
    )
    
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(eateryLocation.coordinate,
      regionRadius * 2.0, regionRadius * 2.0);
    
    eateryPin = EateryPin(
      eatery: eatery,
      title: eatery.name,
      subtitle: eatery.address!
    )
    
    mapView.setRegion(coordinateRegion, animated: true)
    mapView.addAnnotation(eateryPin)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    mapView.selectAnnotation(eateryPin, animated: true)
  }
}
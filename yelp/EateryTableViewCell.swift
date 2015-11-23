//
//  EateryTableViewCell.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/19/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit
import AlamofireImage

class EateryTableViewCell: UITableViewCell {
  
  @IBOutlet var paperView: UIView!
  @IBOutlet var infoView: UIView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var addressLabel: UILabel!
  @IBOutlet var distanceLabel: UILabel!
  @IBOutlet var ratingLabel: UILabel!
  @IBOutlet var reviewCountLabel: UILabel!
  @IBOutlet var previewImageView: UIImageView!
  @IBOutlet var ratingStarsView: UIView!
  
  var eatery: Eatery?
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Initialization
    backgroundColor = Colors.canvas
    
    paperView.layer.shadowOffset = CGSize(width: 0, height: 1)
    paperView.layer.shadowOpacity = 0.25
    paperView.layer.shadowRadius = 2
    
    infoView.layoutMargins = Margins.large
    
    nameLabel.textColor = Colors.text
    addressLabel.textColor = Colors.text
    distanceLabel.textColor = Colors.lightText
    reviewCountLabel.textColor = Colors.lightText
    ratingStarsView.backgroundColor = UIColor.clearColor()
    
    selectionStyle = .None
  }

  func reloadData() {
    nameLabel.text = eatery?.name
    addressLabel.text = eatery?.address
    
    if let met = eatery?.distance {
      distanceLabel.text = String(format: "%.2f miles", arguments: [met/1609.344])
    }
    
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
  }
}

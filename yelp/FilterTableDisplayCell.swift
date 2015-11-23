//
//  FilterTableDisplayCell.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/22/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class FilterTableDisplayCell: UITableViewCell {
  
  @IBOutlet var valueLabel: UILabel!
  @IBOutlet var caretImageView: UIImageView!
  
  var label: String? = nil
  var isExpanded: Bool = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    valueLabel.textColor = Colors.text
    caretImageView.alpha = 0.4
  }
  
  func reloadData() {
    valueLabel.text = label
    caretImageView.transform = CGAffineTransformMakeRotation(isExpanded ? 0 : CGFloat(-M_PI_2))
  }
}

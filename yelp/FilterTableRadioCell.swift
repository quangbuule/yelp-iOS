//
//  FilterTableRadioCell.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/22/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class FilterTableRadioCell: UITableViewCell {
  
  @IBOutlet var radioLabel: UILabel!
  var label: String? = nil
  var active: Bool = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    tintColor = Colors.primary
  }
  
  func reloadData() {
    radioLabel.text = label
    accessoryType = active ? .Checkmark : .None
  }
}

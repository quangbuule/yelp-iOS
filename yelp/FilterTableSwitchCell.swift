//
//  FilterTableViewCell.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/20/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class FilterTableSwitchCell: UITableViewCell {
  
  @IBOutlet var switchLabel: UILabel!
  @IBOutlet var switchControl: UISwitch!
  
  var filterName: FilterViewController.FilterName!
  var label: String? = nil
  var active: Bool = false
  
  var delegate: FilterTableSwitchCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Initialization
    selectionStyle = .None
    switchLabel.textColor = Colors.text

    switchControl.addTarget(self, action: Selector("handleToggle:"), forControlEvents: .ValueChanged)
    switchControl.onTintColor = Colors.primary
  }
  
  func reloadData() {
    switchLabel.text = label
    switchControl.on = active
  }
  
  func handleToggle(sender: UISwitch!) {
    delegate?.filterTableSwitchCell(activeDidChange: sender.on, filterName: filterName)
  }
}

protocol FilterTableSwitchCellDelegate {
  func filterTableSwitchCell(activeDidChange active: Bool, filterName: FilterViewController.FilterName) -> Void
}
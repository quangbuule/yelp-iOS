//
//  eateryTableView.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/20/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class FilterTableView: UITableView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = Colors.canvas
    rowHeight = 50
  }
}

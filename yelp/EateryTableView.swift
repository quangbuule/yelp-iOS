//
//  eateryTableView.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/19/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class EateryTableView: UITableView {
  
  let loadingMoreIndicator = UIActivityIndicatorView()
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = Colors.canvas
    separatorStyle = .None
    
    rowHeight = UITableViewAutomaticDimension
    estimatedRowHeight = 100
    
    loadingMoreIndicator.frame = CGRectMake(0, 0, frame.width, 44)
    
    // TODO: Fix below hot-fix
    contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
    scrollIndicatorInsets = contentInset
  }
}

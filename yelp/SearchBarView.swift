//
//  SearchBarView.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/22/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class SearchBarView: UIView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = Colors.primary
    clipsToBounds = true
    
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowOpacity = 0.25
    layer.shadowRadius = 2
  }
}

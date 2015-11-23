//
//  NavigationController.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/20/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
  
  override func viewDidLoad() {
    navigationBar.barTintColor = Colors.primary
    navigationBar.barStyle = .Black
    navigationBar.tintColor = UIColor.whiteColor()
    
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
    let topView = UIView(frame:
      CGRect(
        x: 0,
        y: -statusBarHeight,
        width: navigationBar.frame.width,
        height: statusBarHeight
      )
    )
    
    topView.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.20)
    
    navigationBar.addSubview(topView)
  }
}

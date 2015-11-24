//
//  EateryListViewController.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/19/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit

class EateryTableViewController: UIViewController {
  
  @IBOutlet var searchBarView: SearchBarView!
  @IBOutlet var queryTextField: UITextField!
  @IBOutlet var filterButton: UIButton!
  @IBOutlet var searchBarHeightConstraint: NSLayoutConstraint!
  @IBOutlet var tableView: EateryTableView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  let refreshControl = UIRefreshControl()
  
  var eateries = EateryCollection()
  var filteringEateries: EateryCollection!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.titleView = UIImageView(image: UIImage(named: "yelp-nav-icon"))
    
    tableView.dataSource = self
    tableView.delegate = self
    
    refreshControl.tintColor = UIColor.lightGrayColor()
    refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: .ValueChanged)
    tableView.addSubview(refreshControl)
    
    activityIndicator.startAnimating()
    
    renderSearchBar()
    hideSearchBar(false)
    fetchEateries {}
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    refreshControl.endRefreshing()
    if tableView.indexPathForSelectedRow != nil {
      tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
    }
  }
  
  func scrollToTop(animated: Bool) {
    let firstRowIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    tableView.scrollToRowAtIndexPath(firstRowIndexPath, atScrollPosition: .Top, animated: true)
  }
}

extension EateryTableViewController {
  
  func renderSearchBar() {
    filterButton.tintColor = UIColor.whiteColor()
    // TODO: Add icons
  }
  @IBAction func handleQueryChange(sender: UITextField) {
    eateries = eateries.copyForFiltering()
    
    eateries.term = sender.text!
    tableView.reloadData()
    view.endEditing(true)
    fetchEateries(){}
  }
  
  func showSearchBar(animated: Bool) {
    func layout() {
      self.searchBarHeightConstraint.constant = 44
      self.view.layoutIfNeeded()
    }
    
    if (!animated) {
      layout()
      return
    }
    
    UIView.animateWithDuration(
      0.2,
      delay: 0,
      options: .CurveEaseOut,
      animations: layout,
      completion: { _ in }
    );
  }
  
  func hideSearchBar(animated: Bool) {
    func layout() {
      self.searchBarHeightConstraint.constant = 0
      self.view.layoutIfNeeded()
    }
    
    view.endEditing(true)
    
    if (!animated) {
      layout()
      return
    }
    
    UIView.animateWithDuration(
      0.2,
      delay: 0,
      options: .CurveEaseOut,
      animations: layout,
      completion: { _ in }
    );
  }
  
  @IBAction func handleSearchButtonTap(sender: UIBarButtonItem) {
    if searchBarHeightConstraint.constant == 0 {
      showSearchBar(true)
      
    } else {
      hideSearchBar(true)
    }
  }
  
  @IBAction func handleTap(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
}

extension EateryTableViewController {
  
  func fetchEateries(done: () -> Void) {
    activityIndicator.hidden = false
    
    eateries.fetch(
      done: { _ in
        self.tableView.reloadData()
        done()
      },
      fail: { _ in
        // TODO: Handle failure
      }
    )
  }
  
  func fetchMoreEateries() {
    if !eateries.done || eateries.full {
      return
    }
    
    eateries.fetchMore(
      done: { _ in
        if self.eateries.full {
          self.activityIndicator.hidden = true
        }
        self.tableView.reloadData()
      },
      fail: { _ in
        // TODO: Handle failure
      }
    )
  }
  
  func refresh(sender: AnyObject) {
    self.refreshControl.beginRefreshing()
    
    fetchEateries {
      dispatch_async(dispatch_get_main_queue()) {
        self.refreshControl.endRefreshing()
      }
    }
  }
}

extension EateryTableViewController: FilterViewDelegate {
  func filterView(isCellActiveForFilterWithName name: FilterViewController.FilterName, filterValue value: AnyObject) -> Bool {
    switch name {
    case .Deals:
      return filteringEateries.deals
      
    case .Distance:
      return filteringEateries.distance == value as! Float
      
    case .Sort:
      return filteringEateries.sort == value as! Int
      
    case .Category(let name):
      if let active = filteringEateries.categories[name] {
        return active
      }
      
      return false
    }
  }
  
  func filterView(valueForFilterWithName name: FilterViewController.FilterName) -> AnyObject {
    switch name {
    case .Distance:
      return filteringEateries.distance
      
    case .Sort:
      return filteringEateries.sort
      
    default:
      return ""
    }
  }
  
  func filterView(valueWillChangeAtFilterWithName name: FilterViewController.FilterName, value: AnyObject) {
    switch name {
    case .Deals:
      filteringEateries.deals = value as! Bool
      break
      
    case .Distance:
      filteringEateries.distance = value as! Float
      break
      
    case .Sort:
      filteringEateries.sort = value as! Int
      break
      
    case .Category(let categoryName):
      if value as! Bool {
        filteringEateries.categories[categoryName] = true
        
      } else {
        filteringEateries.categories.removeValueForKey(categoryName)
      }
      break
    }
  }
  
  func filterView(viewWillDismiss done: Bool) {
    if done {
      eateries = filteringEateries
      tableView.reloadData()
      fetchEateries(){}
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "filterSegue" {
      filteringEateries = eateries.copyForFiltering()
      (segue.destinationViewController as! FilterViewController).delegate = self
    }
    
    if segue.identifier == "mapSegue" {
      let mapViewController = segue.destinationViewController as! MapViewController
      mapViewController.eateries = eateries
    }
    
    if segue.identifier == "detailSegue" {
      let selectedCell = sender as! EateryTableViewCell
      let mapViewController = segue.destinationViewController as! EateryDetailViewController

      mapViewController.eatery = selectedCell.eatery
    }
  }
}

extension EateryTableViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("eateryCell") as! EateryTableViewCell
    
    cell.eatery = eateries.get(indexPath.row)
    cell.reloadData()
    
    if indexPath.row >= eateries.count - 10 {
      fetchMoreEateries()
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return eateries.count
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    view.endEditing(true)
  }
}
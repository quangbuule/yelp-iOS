//
//  FilterViewController.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/20/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit
import Dollar

class FilterViewController: UIViewController {
  
  // MARK: Properties
  @IBOutlet var filterTableView: FilterTableView!

  var filterSets: [FilterSet]!
  var delegate: FilterViewDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialization
    title = "Filter"
    
    filterSets = FilterViewController.defaultFilterSets

    filterTableView.dataSource = self
    filterTableView.delegate = self
  }
  
  @IBAction func handleSearchButtonTap(sender: UIBarButtonItem) {
    navigationController?.popViewControllerAnimated(true)
    delegate.filterView(viewWillDismiss: true)
  }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate, FilterTableSwitchCellDelegate {
  
  static let defaultFilterSets: [FilterSet] = [
    FilterSet(
      title: nil,
      type: .Switch,
      items: [
        FilterItem(
          name: .deals,
          value: YelpClient.Filters.deal["value"] as! Bool,
          label: YelpClient.Filters.deal["label"] as? String
        )
      ]
    ),
    
    FilterSet(
      title: "Distance",
      type: .Radio(name: "distance"),
      items: YelpClient.Filters.distances.map {datum in
          return FilterItem(
            name: .distance,
            value: datum["value"] as! Float,
            label: datum["label"] as? String
          )
      },
      isExpandable: true
    ),
    
    FilterSet(
      title: "Sort by",
      type: .Radio(name: "sort"),
      items: YelpClient.Filters.sorts.map {datum in
        return FilterItem(
          name: .sort,
          value: datum["value"] as! Int,
          label: datum["label"] as? String
        )
      },
      isExpandable: true
    ),
    
    FilterSet(
      title: "Category",
      type: .Switch,
      items: YelpClient.Filters.categories.map {datum in
        return FilterItem(
          name: .category(name: datum["value"] as! String),
          value: datum["value"] as! String,
          label: datum["label"] as? String
        )
      },
      minNumOfRows: 3,
      isExpandable: true
    )
  ]
  
  // MARK: tableView manipulation
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return filterSets.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return filterSets[section].title
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let filterSet = filterSets[section]
    
    switch filterSet.type {
    case .Switch:
      // If the filterSet is expandable, add 1 more row for Expand/Collapse button
      return filterSet.visibleRowCount + (filterSet.isExpandable ? 1 : 0)
      
    case .Radio:
      // The first row is to display value
      return (filterSet.isExpanded ? filterSet.items.count : 0) + 1
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let filterSet = filterSets[indexPath.section]
    
    switch filterSet.type {
    case .Switch:
      if indexPath.row == filterSet.visibleRowCount {
        // The last cell - to toggle Expand/Collapse
        return tableView.dequeueReusableCellWithIdentifier(filterSet.isExpanded ? "collapseCell" : "expandCell")!
      }
      
      let cell = tableView.dequeueReusableCellWithIdentifier("switchCell") as! FilterTableSwitchCell
      let filterItem = filterSet.items[indexPath.row]
      
      cell.filterName = filterItem.name
      cell.label = filterItem.label
      cell.active = delegate.filterView(isCellActiveForFilterWithName: filterItem.name, filterValue: filterItem.value)
      cell.delegate = self
  
      cell.reloadData()
      return cell
      
    case .Radio( _):
      if indexPath.row == 0 {
        // The first cell - to display value and toggle Expand/Collapse
        let cell = tableView.dequeueReusableCellWithIdentifier("displayCell") as! FilterTableDisplayCell
        
        cell.label = $.find(filterSet.items) { filterItem in
          return filterItem.value.isEqual(self.delegate.filterView(valueForFilterWithName: filterItem.name))
        }?.label
        cell.isExpanded = filterSet.isExpanded
        
        cell.reloadData()
        return cell
      }
      
      let filterItem = filterSet.items[indexPath.row - 1]
      
      let cell = tableView.dequeueReusableCellWithIdentifier("radioCell") as! FilterTableRadioCell
      
      cell.label = filterItem.label
      cell.active = delegate.filterView(isCellActiveForFilterWithName: filterItem.name, filterValue: filterItem.value)
      
      cell.reloadData()
      return cell
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let filterSet = filterSets[indexPath.section]
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    func toggleExpanded() {
      filterSet.isExpanded = !filterSet.isExpanded
      tableView.reloadData()
    }
    
    var needAnimationRowIndexPaths: [NSIndexPath]!

    // Animation
    switch filterSet.type {
    case .Switch:
      if indexPath.row != filterSet.visibleRowCount {
        return
      }
      
      let start = filterSet.minNumOfRows
      
      needAnimationRowIndexPaths = $.slice(filterSet.items, start: start).enumerate()
        .map { index, _ in
          return NSIndexPath(forRow: index + start, inSection: indexPath.section)
      }
      break
      
    case .Radio( _):
      if indexPath.row != 0 {
        let filterItem = filterSet.items[indexPath.row - 1]
        delegate.filterView(valueWillChangeAtFilterWithName: filterItem.name, value: filterItem.value)
      }
      
      needAnimationRowIndexPaths = filterSet.items.enumerate().map { index, _ in
        return NSIndexPath(forRow: index + 1, inSection: indexPath.section)
      }
      
      break
    }
    
    
    if filterSet.isExpanded {
      tableView.reloadRowsAtIndexPaths(needAnimationRowIndexPaths, withRowAnimation: .Top)
      toggleExpanded()
      
    } else {
      toggleExpanded()
      tableView.reloadRowsAtIndexPaths(needAnimationRowIndexPaths, withRowAnimation: .Bottom)
    }
  }
  
  func filterTableSwitchCell(activeDidChange active: Bool, filterName: FilterViewController.FilterName) {
    delegate.filterView(valueWillChangeAtFilterWithName: filterName, value: active)
  }
}

extension FilterViewController {
  
  enum FilterName {
    case deals
    case distance
    case sort
    case category(name: String)
  }
  
  // MARK: Filtering structs
  struct FilterItem {
    
    // Properties
    let name: FilterName
    let value: AnyObject
    let label: String?
  }
  
  class FilterSet {
    
    enum Type {
      case Switch
      case Radio(name: String)
    }
    
    // Properties
    let title: String?
    let type: Type
    let items: [FilterItem]
    let isExpandable: Bool
    var isExpanded: Bool
    let minNumOfRows: Int
    
    var visibleRowCount: Int {
      get {
        switch type {
        case .Switch:
          if (isExpandable) {
            return isExpanded ? items.count : minNumOfRows
          }
          
          return items.count
          
        case .Radio:
          return isExpanded ? items.count : 0
        }
      }
    }
    
    // Initialization
    init(title: String?, type: Type, items: [FilterItem], minNumOfRows: Int, isExpandable: Bool = true, isExpanded: Bool = false) {
      self.title = title
      self.type = type
      self.items = items
      self.minNumOfRows = minNumOfRows
      self.isExpandable = isExpandable
      self.isExpanded = isExpanded
    }
    
    convenience init(title: String?, type: Type, items: [FilterItem], isExpandable: Bool = false, isExpanded: Bool = false) {
      self.init(title: title, type: type, items: items, minNumOfRows: 3, isExpandable: false, isExpanded: isExpanded)
    }
  }
}

protocol FilterViewDelegate {
  func filterView(isCellActiveForFilterWithName name: FilterViewController.FilterName, filterValue value: AnyObject) -> Bool
  func filterView(valueForFilterWithName name: FilterViewController.FilterName) -> AnyObject
  func filterView(valueWillChangeAtFilterWithName name: FilterViewController.FilterName, value: AnyObject) -> Void
  func filterView(viewWillDismiss done: Bool) -> Void
}
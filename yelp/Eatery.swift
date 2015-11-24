//
//  Eatery.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/21/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import Alamofire
import Dollar

class Eatery: RestfulEntity {
  
  let name: String
  let address: String?
  let phone: String?
  let rating: Float?
  let reviewCount: Int?
  let distance: Float?
  let imageURLString: String?
  
  let latitude: Float
  let longitude: Float
  
  required init(rawData: NSDictionary) {
    name = rawData["name"] as! String
    phone = rawData["display_phone"] as? String
    rating = rawData["rating"] as? Float
    reviewCount = rawData["review_count"] as? Int
    distance = rawData["distance"] as? Float
    latitude = rawData.valueForKeyPath("location.coordinate.latitude") as! Float
    longitude = rawData.valueForKeyPath("location.coordinate.longitude") as! Float
    imageURLString = {() -> String? in
      if let s = rawData["image_url"] as? String {
        let regex = try! NSRegularExpression(pattern: "/ms", options: .CaseInsensitive)
        return regex.stringByReplacingMatchesInString(s, options: [], range: NSRange(0...s.utf16.count-1), withTemplate: "/sl")
      }
      
      return nil
    }()
    
    let addressParts = rawData.valueForKeyPath("location.display_address") as! [String]
    
    if addressParts.count > 2 {
      address = Array(addressParts[0...1]).joinWithSeparator(", ")
      
    } else {
      address = addressParts.joinWithSeparator(", ")
    }
  }
}

class EateryCollection: RestfulCollection<Eatery> {
  
  var offset = 0
  let limit = 20

  var term = ""
  var deals = false
  var distance: Float = 0
  var sort: Int = 0
  var categories: [String:Bool] = [:]
  
  private let initialParamerters: [String: AnyObject] = [
    "ll": "37.785771,-122.406165"
  ]
  
  var parameters: [String: AnyObject] {
    get {
      var parameters = $.merge(initialParamerters, [
        "term": term,
        "limit": limit,
        "offset": offset,
        "deals_filter": deals,
        "sort": sort
        ]
      )
      
      let category = (categories.map { name, selected in
        return selected ? name : ""
      }).joinWithSeparator(",")
      
      if category != "" {
        print(categories, category)
        parameters["category_filter"] = category
      }
      
      if distance != 0 {
        parameters = $.merge(parameters, ["radius": distance])
      }
      
      return parameters
    }
  }
  
  func copyForFiltering() -> EateryCollection {
    let eateryCollection = EateryCollection()
    
    eateryCollection.term = term
    eateryCollection.deals = deals
    eateryCollection.distance = distance
    eateryCollection.sort = sort
    eateryCollection.categories = categories
    
    return eateryCollection
  }
  
  override func request() -> Request? {
    offset = 0
    
    return YelpClient.sharedInstance.request(
      .GET,
      path: "/search",
      parameters: parameters
    );
  }
  
  override func request(more: Bool) -> Request? {
    return YelpClient.sharedInstance.request(
      .GET,
      path: "/search",
      parameters: parameters
    )
  }
  
  override func response(response: Response<AnyObject, NSError>, rawData: Any?) -> [NSDictionary]? {
    // It's so wrong, I have to do side effect?
    let castedRawData = response.result.value!["businesses"] as? [NSDictionary]

    if let count = castedRawData?.count {
      offset += count
    }
    
    return castedRawData
  }
}

//
//  RestfulCollection.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/21/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//
import Alamofire
import Foundation

class RestfulCollection<T: RestfulEntity> {
  var items = [T]()
  
  var fetching: Bool = false
  var failed: Bool = false
  var done: Bool = false
  var total: Int = 0
  var full: Bool = false
  
  var count: Int {
    get {
      return self.items.count
    }
  }
  
  internal func request() -> Alamofire.Request? {
    return nil
  }
  
  // TODO: Rename below func _.__"
  internal func request(more: Bool) -> Alamofire.Request? {
    return nil
  }
  
  internal func response(response: Response<AnyObject, NSError>, rawData: Any?) -> [NSDictionary]? {
    return nil
  }
  
  func fetch(done done: (RestfulCollection<T>) -> Void, fail: (NSError?) -> Void) {
    if fetching {
      // TODO: Handle noop
      return
    }
    
    fetching = true
    full = false
    
    request()?.responseJSON { response in
      if let error = response.result.error {
        self.fetching = false
        self.failed = true
        
        fail(error)
        return
      }
      
      if let _ = response.result.value {
        self.fetching = false
        self.failed = false
        self.done = true
        
        self.items = self.response(response, rawData: nil)!.map { rawData in
          return T(rawData: rawData)
        }
        
        done(self)
      }
    }
  }
  
  
  func fetchMore(done done: (RestfulCollection<T>) -> Void, fail: (NSError?) -> Void) {
    if fetching {
      // TODO: Handle noop
      return
    }
    
    fetching = true
    request(true)?.responseJSON { response in
      if let error = response.result.error {
        self.fetching = false
        self.failed = true
        
        fail(error)
        return
      }
      
      if let _ = response.result.value {
        let prevCount = self.count
        
        self.fetching = false
        self.failed = false
        
        self.items += self.response(response, rawData: nil)!.map { rawData in
          return T(rawData: rawData)
        }
        
        if (self.count == prevCount) {
          self.full = true
        }
        
        done(self)
      }
    }
    
    // TODO: Prepare pagination
    
    //    let request = {() -> Alamofire.Request in
    //      let mutableRequest = Alamofire.request(.GET, self.requestURLString, parameters: self.parameters)
    //        .request as! NSMutableURLRequest
    //
    //      mutableRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
    //      return Alamofire.request(mutableRequest)
    //    }()
    
    //    request
    //      .responseJSON { response in
    //        if let JSON = response.result.value {
    //          self.fetching = false
    //          self.failed = false
    //
    //          self.items += (JSON["results"] as! [NSDictionary]).map { movieRawData in
    //            return Eatery(rawData: movieRawData)
    //          }
    //
    //          done(self)
    //        }
    //
    //        if let error = response.result.error {
    //          self.fetching = false
    //          self.failed = true
    //
    //          fail(error)
    //        }
    //    }
  }
  
  func get(index: Int) -> T? {
    return index < items.count ? self.items[index] : nil
  }
}


protocol RestfulEntity {
  init(rawData: NSDictionary)
}
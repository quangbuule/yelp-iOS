//
//  YelpClient.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/21/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import OAuthSwift
import Alamofire

class YelpClient {
  
  // TODO: Think about getting rid of singleton
  static let sharedInstance = YelpClient()
  
  private let apiURLPrefix = "https://api.yelp.com/v2"
  private let oauthClient = {() -> OAuthSwiftClient in
    let oauthClient = OAuthSwiftClient(
      consumerKey: "vxKwwcR_NMQ7WaEiQBK_CA",
      consumerSecret: "33QCvh5bIF5jIHR5klQr7RtBDhQ",
      accessToken: "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV",
      accessTokenSecret: "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    )
    
    oauthClient.credential.oauth_header_type = "oauth1"
    return oauthClient
  }()
  
  func request(method: Alamofire.Method, path: String, parameters: [String: AnyObject], usingCache: Bool = false) -> Request {
    let URLString = "\(apiURLPrefix)\(path)"
    let headers = oauthClient.credential.makeHeaders(NSURL(string: URLString)!, method: String(method), parameters: parameters)
    var request = Alamofire.request(method, URLString, parameters: parameters, encoding: .URL, headers: headers)
    
    if (!usingCache) {
      let mutableRequest = request.request as! NSMutableURLRequest
      
      mutableRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
      request = Alamofire.request(mutableRequest)
    }
    
    return request
  }
}

extension YelpClient {
  struct Filters {
    static let deal: [String: AnyObject] = [
      "label": "Offering a Deal",
      "value": true
    ]
    static let distances: [[String: AnyObject]] = [
      ["label": "Auto", "value": 0],
      ["label": "0.3 miles", "value": 482.8032],
      ["label": "1 mile", "value": 1609.344],
      ["label": "5 miles", "value": 8046.720],
      ["label": "20 miles", "value": 32186.88]
    ]
    static let sorts:[[String: AnyObject]] = [
      ["label": "Best matched", "value": 0],
      ["label": "Distance", "value": 1],
      ["label": "High rated", "value": 2]
    ]
    static let categories: [[String: AnyObject]] = [
      ["label": "Afghan", "value": "afghani"],
      ["label": "African", "value": "african"],
      ["label": "American, New", "value": "newamerican"],
      ["label": "American, Traditional", "value": "tradamerican"],
      ["label": "Arabian", "value": "arabian"],
      ["label": "Argentine", "value": "argentine"],
      ["label": "Armenian", "value": "armenian"],
      ["label": "Asian Fusion", "value": "asianfusion"],
      ["label": "Asturian", "value": "asturian"],
      ["label": "Australian", "value": "australian"],
      ["label": "Austrian", "value": "austrian"],
      ["label": "Baguettes", "value": "baguettes"],
      ["label": "Bangladeshi", "value": "bangladeshi"],
      ["label": "Barbeque", "value": "bbq"],
      ["label": "Basque", "value": "basque"],
      ["label": "Bavarian", "value": "bavarian"],
      ["label": "Beer Garden", "value": "beergarden"],
      ["label": "Beer Hall", "value": "beerhall"],
      ["label": "Beisl", "value": "beisl"],
      ["label": "Belgian", "value": "belgian"],
      ["label": "Bistros", "value": "bistros"],
      ["label": "Black Sea", "value": "blacksea"],
      ["label": "Brasseries", "value": "brasseries"],
      ["label": "Brazilian", "value": "brazilian"],
      ["label": "Breakfast & Brunch", "value": "breakfast_brunch"],
      ["label": "British", "value": "british"],
      ["label": "Buffets", "value": "buffets"],
      ["label": "Bulgarian", "value": "bulgarian"],
      ["label": "Burgers", "value": "burgers"],
      ["label": "Burmese", "value": "burmese"],
      ["label": "Cafes", "value": "cafes"],
      ["label": "Cafeteria", "value": "cafeteria"],
      ["label": "Cajun/Creole", "value": "cajun"],
      ["label": "Cambodian", "value": "cambodian"],
      ["label": "Canadian", "value": "New)"],
      ["label": "Canteen", "value": "canteen"],
      ["label": "Caribbean", "value": "caribbean"],
      ["label": "Catalan", "value": "catalan"],
      ["label": "Chech", "value": "chech"],
      ["label": "Cheesesteaks", "value": "cheesesteaks"],
      ["label": "Chicken Shop", "value": "chickenshop"],
      ["label": "Chicken Wings", "value": "chicken_wings"],
      ["label": "Chilean", "value": "chilean"],
      ["label": "Chinese", "value": "chinese"],
      ["label": "Comfort Food", "value": "comfortfood"],
      ["label": "Corsican", "value": "corsican"],
      ["label": "Creperies", "value": "creperies"],
      ["label": "Cuban", "value": "cuban"],
      ["label": "Curry Sausage", "value": "currysausage"],
      ["label": "Cypriot", "value": "cypriot"],
      ["label": "Czech", "value": "czech"],
      ["label": "Czech/Slovakian", "value": "czechslovakian"],
      ["label": "Danish", "value": "danish"],
      ["label": "Delis", "value": "delis"],
      ["label": "Diners", "value": "diners"],
      ["label": "Dumplings", "value": "dumplings"],
      ["label": "Eastern European", "value": "eastern_european"],
      ["label": "Ethiopian", "value": "ethiopian"],
      ["label": "Fast Food", "value": "hotdogs"],
      ["label": "Filipino", "value": "filipino"],
      ["label": "Fish & Chips", "value": "fishnchips"],
      ["label": "Fondue", "value": "fondue"],
      ["label": "Food Court", "value": "food_court"],
      ["label": "Food Stands", "value": "foodstands"],
      ["label": "French", "value": "french"],
      ["label": "French Southwest", "value": "sud_ouest"],
      ["label": "Galician", "value": "galician"],
      ["label": "Gastropubs", "value": "gastropubs"],
      ["label": "Georgian", "value": "georgian"],
      ["label": "German", "value": "german"],
      ["label": "Giblets", "value": "giblets"],
      ["label": "Gluten-Free", "value": "gluten_free"],
      ["label": "Greek", "value": "greek"],
      ["label": "Halal", "value": "halal"],
      ["label": "Hawaiian", "value": "hawaiian"],
      ["label": "Heuriger", "value": "heuriger"],
      ["label": "Himalayan/Nepalese", "value": "himalayan"],
      ["label": "Hong Kong Style Cafe", "value": "hkcafe"],
      ["label": "Hot Dogs", "value": "hotdog"],
      ["label": "Hot Pot", "value": "hotpot"],
      ["label": "Hungarian", "value": "hungarian"],
      ["label": "Iberian", "value": "iberian"],
      ["label": "Indian", "value": "indpak"],
      ["label": "Indonesian", "value": "indonesian"],
      ["label": "International", "value": "international"],
      ["label": "Irish", "value": "irish"],
      ["label": "Island Pub", "value": "island_pub"],
      ["label": "Israeli", "value": "israeli"],
      ["label": "Italian", "value": "italian"],
      ["label": "Japanese", "value": "japanese"],
      ["label": "Jewish", "value": "jewish"],
      ["label": "Kebab", "value": "kebab"],
      ["label": "Korean", "value": "korean"],
      ["label": "Kosher", "value": "kosher"],
      ["label": "Kurdish", "value": "kurdish"],
      ["label": "Laos", "value": "laos"],
      ["label": "Laotian", "value": "laotian"],
      ["label": "Latin American", "value": "latin"],
      ["label": "Live/Raw Food", "value": "raw_food"],
      ["label": "Lyonnais", "value": "lyonnais"],
      ["label": "Malaysian", "value": "malaysian"],
      ["label": "Meatballs", "value": "meatballs"],
      ["label": "Mediterranean", "value": "mediterranean"],
      ["label": "Mexican", "value": "mexican"],
      ["label": "Middle Eastern", "value": "mideastern"],
      ["label": "Milk Bars", "value": "milkbars"],
      ["label": "Modern Australian", "value": "modern_australian"],
      ["label": "Modern European", "value": "modern_european"],
      ["label": "Mongolian", "value": "mongolian"],
      ["label": "Moroccan", "value": "moroccan"],
      ["label": "New Zealand", "value": "newzealand"],
      ["label": "Night Food", "value": "nightfood"],
      ["label": "Norcinerie", "value": "norcinerie"],
      ["label": "Open Sandwiches", "value": "opensandwiches"],
      ["label": "Oriental", "value": "oriental"],
      ["label": "Pakistani", "value": "pakistani"],
      ["label": "Parent Cafes", "value": "eltern_cafes"],
      ["label": "Parma", "value": "parma"],
      ["label": "Persian/Iranian", "value": "persian"],
      ["label": "Peruvian", "value": "peruvian"],
      ["label": "Pita", "value": "pita"],
      ["label": "Pizza", "value": "pizza"],
      ["label": "Polish", "value": "polish"],
      ["label": "Portuguese", "value": "portuguese"],
      ["label": "Potatoes", "value": "potatoes"],
      ["label": "Poutineries", "value": "poutineries"],
      ["label": "Pub Food", "value": "pubfood"],
      ["label": "Rice", "value": "riceshop"],
      ["label": "Romanian", "value": "romanian"],
      ["label": "Rotisserie Chicken", "value": "rotisserie_chicken"],
      ["label": "Rumanian", "value": "rumanian"],
      ["label": "Russian", "value": "russian"],
      ["label": "Salad", "value": "salad"],
      ["label": "Sandwiches", "value": "sandwiches"],
      ["label": "Scandinavian", "value": "scandinavian"],
      ["label": "Scottish", "value": "scottish"],
      ["label": "Seafood", "value": "seafood"],
      ["label": "Serbo Croatian", "value": "serbocroatian"],
      ["label": "Signature Cuisine", "value": "signature_cuisine"],
      ["label": "Singaporean", "value": "singaporean"],
      ["label": "Slovakian", "value": "slovakian"],
      ["label": "Soul Food", "value": "soulfood"],
      ["label": "Soup", "value": "soup"],
      ["label": "Southern", "value": "southern"],
      ["label": "Spanish", "value": "spanish"],
      ["label": "Steakhouses", "value": "steak"],
      ["label": "Sushi Bars", "value": "sushi"],
      ["label": "Swabian", "value": "swabian"],
      ["label": "Swedish", "value": "swedish"],
      ["label": "Swiss Food", "value": "swissfood"],
      ["label": "Tabernas", "value": "tabernas"],
      ["label": "Taiwanese", "value": "taiwanese"],
      ["label": "Tapas Bars", "value": "tapas"],
      ["label": "Tapas/Small Plates", "value": "tapasmallplates"],
      ["label": "Tex-Mex", "value": "tex-mex"],
      ["label": "Thai", "value": "thai"],
      ["label": "Traditional Norwegian", "value": "norwegian"],
      ["label": "Traditional Swedish", "value": "traditional_swedish"],
      ["label": "Trattorie", "value": "trattorie"],
      ["label": "Turkish", "value": "turkish"],
      ["label": "Ukrainian", "value": "ukrainian"],
      ["label": "Uzbek", "value": "uzbek"],
      ["label": "Vegan", "value": "vegan"],
      ["label": "Vegetarian", "value": "vegetarian"],
      ["label": "Venison", "value": "venison"],
      ["label": "Vietnamese", "value": "vietnamese"],
      ["label": "Wok", "value": "wok"],
      ["label": "Wraps", "value": "wraps"]
    ]
  }
}
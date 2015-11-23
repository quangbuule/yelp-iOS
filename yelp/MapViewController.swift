//
//  MapViewController.swift
//  yelp
//
//  Created by Lê Quang Bửu on 11/23/15.
//  Copyright © 2015 Lê Quang Bửu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
  
  @IBOutlet var mapView: MKMapView!
  
  var initialLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
  let regionRadius: CLLocationDistance = 2000
  var eateries: EateryCollection!
 
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    centerMapOnLocation(initialLocation)

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    reloadData()
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
      regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    let view = MKPinAnnotationView()
    
    view.canShowCallout = true
    view.calloutOffset = CGPoint(x: -5, y: 5)
    view.rightCalloutAccessoryView = UIButton(type: .InfoLight) as UIView
    view.pinTintColor = Colors.primary
    
    return view
  }
  
  func reloadData() {
    eateries.items.forEach { eatery in
      let eateryPin = EateryPin(
        coordinate: CLLocationCoordinate2D(latitude: Double(eatery.latitude), longitude: Double(eatery.longitude)),
        title: eatery.name,
        subtitle: eatery.address!
      )
      
      self.mapView.addAnnotation(eateryPin)

    }
  }
}

class EateryPin: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?
  
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
  }
}
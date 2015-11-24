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
    title = "Maps"
    centerMapOnLocation(initialLocation)

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    eateries.items.forEach { eatery in
      let eateryPin = EateryPin(
        eatery: eatery,
        title: eatery.name,
        subtitle: eatery.address!
      )
      
      self.mapView.addAnnotation(eateryPin)
    }
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
    view.tintColor = Colors.text
    
    return view
  }
  
  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let eateryPin = view.annotation as! EateryPin
    performSegueWithIdentifier("detailSegue", sender: eateryPin)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "detailSegue" {
      (segue.destinationViewController as! EateryDetailViewController).eatery = (sender as! EateryPin).eatery
    }
  }
}

class EateryPin: NSObject, MKAnnotation {
  
  let eatery: Eatery!
  let coordinate: CLLocationCoordinate2D
  let title: String?
  let subtitle: String?
  
  init(eatery: Eatery, title: String, subtitle: String) {
    self.eatery = eatery
    self.coordinate = CLLocationCoordinate2D(latitude: Double(eatery.latitude), longitude: Double(eatery.longitude))
    self.title = title
    self.subtitle = subtitle
  }
}
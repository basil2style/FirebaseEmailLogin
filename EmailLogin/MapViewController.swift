//
//  MapViewController.swift
//  EmailLogin
//
//  Created by Basil on 2016-11-17.
//  Copyright © 2016 Makeinfo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase


class MapViewController :UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
       /* let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Posts").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            
            // let title  = snapshot.value as? ["title";]
            let title = (snapshot.value as? NSDictionary)?["title"] as? String ?? ""
            //let message = snapshot.value!["message"] as! String
            var lat = (snapshot.value as? NSDictionary)?["Latitude"] as? String ?? ""
            var lon = (snapshot.value as? NSDictionary)?["Longitude"] as? String ?? "
            
            if lat == nil && lon == nil {
                lat = "0.0"
                lon = "0.0"
            }
            
            var location = CLLocationCoordinate2DMake(Double(lat)!, Double(lon)!)
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            annotation.subtitle = "Toronto"
            
            self.mapView.addAnnotation(annotation)
 
         
        }) */
        
        
      /*  var location = CLLocationCoordinate2DMake(43.653226, -79.383184)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Pizza Store"
        annotation.subtitle = "Toronto"
        
        mapView.addAnnotation(annotation) */
        if locationManager == nil {
        locationManager = CLLocationManager()
        }
        
        //locationManager!.delegate
        locationManager!.requestAlwaysAuthorization()
        
        post()
        
        
    }
    
    func post() {
        
        let address = getCoordinate()
        let post = ["title":"Test" as String,"Latitude":address.lat as Double,"Longitude":address.lon as Double] as [String : Any]
        
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("Posts").childByAutoId().setValue(post)
        
    }
    func getCoordinate() -> (lat:Double,lon:Double) {
        
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        locManager.requestAlwaysAuthorization()
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedAlways){
            
            currentLocation = locManager.location!
            
        }
        
        return (currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

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
import FirebaseAuth


class MapViewController :UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let databaseRef = FIRDatabase.database().reference()
    let annotation = MKPointAnnotation()
    
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
    
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
       // post()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        post(location: location!)
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
        
        mapView.removeAnnotation(annotation)
        annotation.coordinate = center
        annotation.title = FIRAuth.auth()?.currentUser?.email
        annotation.subtitle = "Toronto"
        self.mapView.addAnnotation(annotation)
        
        databaseRef.child("Locations").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            
            let email = (snapshot.value as? NSDictionary)?["Email"] as? String ?? ""
            print(email)
            
        })
        
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Errors:" + error.localizedDescription)
    }
    
    
    func post(location : CLLocation) {
        
        let currentUser = FIRAuth.auth()?.currentUser
        let currentEmail = currentUser?.email
        let currentUid = currentUser?.uid
        
       // let address = getCoordinate()
        let post = ["Email":currentEmail! as String,"UserId":currentUid! as String,"Latitude":location.coordinate.latitude ,"Longitude":location.coordinate.longitude,"Timestamp":NSDate().timeIntervalSince1970*1000 ] as [String : Any]
        
       
        //databaseRef.removeValue()
        //databaseRef.child("Locations/").childByAutoId().setValue(post)
        databaseRef.child("Locations/").child(currentUid!).updateChildValues(post)
        
    }
}

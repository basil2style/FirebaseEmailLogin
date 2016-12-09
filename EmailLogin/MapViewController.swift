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
    var annotationCount: [String: MKPointAnnotation] = [:]
   // var annotationCounter : [String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
       // post()
    
     //   self.mapView.removeAnnotation(annotation)
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        post(location: location!)
        

        databaseRef.child("Locations").observeSingleEvent(of: .value, with: { snapshot in
            
            
            if snapshot.value is NSNull {
                
            }else {
                let snapDic = snapshot.value as? NSDictionary
                for child in snapDic! {
                let childDic = child.value as? NSDictionary
                let email = childDic?["Email"] as! String
                let lat = childDic?["Latitude"] as! NSNumber
                let lon = childDic?["Longitude"] as! NSNumber
                let lastTime = childDic?["Timestamp"] as! NSNumber
                    
                print("Email:\(email) & Location: \(lat) + \(lon)")
                
                var testVar: Int = 0
               //let annotation = MKPointAnnotation()
                let tmpAnnotation = MKPointAnnotation()
                    
                /*self.annotation.title = email
                let dateTime = String(describing: lastTime)
                self.annotation.subtitle = "Last Updated: "+dateTime
                self.annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
                //print(self.mapView.annotations.description)
                self.mapView.addAnnotation(self.annotation)
                */
                if (email != FIRAuth.auth()?.currentUser?.email){
                    self.mapView.removeAnnotation(tmpAnnotation)
                    tmpAnnotation.title = email
                    let dateTime = String(describing: lastTime)
                    tmpAnnotation.subtitle = "Last Updated: "+dateTime
                    tmpAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
                  
                    if self.annotationCount.index(forKey: email) == nil {
                        self.annotationCount[email] = tmpAnnotation
                    }
                    else {
                        self.mapView.removeAnnotation(self.annotationCount[email]!)
                        self.annotationCount.updateValue(tmpAnnotation, forKey: email)
                    }
 
                    
                    
                    
                    self.mapView.addAnnotation(tmpAnnotation)
                    
                }
                
                
                }
                }
            
        })
                self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Errors:" + error.localizedDescription)
    }
    
    
    func post(location : CLLocation) {
        
        mapView.removeAnnotation(annotation)
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let currentUser = FIRAuth.auth()?.currentUser
        let currentEmail = currentUser?.email
        let currentUid = currentUser?.uid
        let Timestamp = NSDate().timeIntervalSince1970*1000
        annotation.title = currentEmail
        annotation.subtitle = "Last Updated: "+String(Timestamp)
        self.mapView.addAnnotation(annotation)
       // let address = getCoordinate()
        let post = ["Email":currentEmail! as String,"UserId":currentUid! as String,"Latitude":location.coordinate.latitude ,"Longitude":location.coordinate.longitude,"Timestamp":Timestamp] as [String : Any]
        
       
        //databaseRef.removeValue()
        //databaseRef.child("Locations/").childByAutoId().setValue(post)
        databaseRef.child("Locations/").child(currentUid!).updateChildValues(post)
        
    }
}

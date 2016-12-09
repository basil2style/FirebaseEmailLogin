//
//  MapViewController.swift
//  EmailLogin
//
//  Created by Basil on 2016-11-17.
//  Student Name: Basil Alias
//  Student ID: 300919992
//  Copyright © 2016 Makeinfo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth


class MapViewController :UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()                   //Location Manager
    let databaseRef = FIRDatabase.database().reference()        // Firebase Database reference
    let annotation = MKPointAnnotation()                        // Creating annotation for current user
    var annotationCount: [String: MKPointAnnotation] = [:]      // annotation HashMap for refreshing annotation
   // var annotationCounter : [String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest  //For Better Accuracy
        self.locationManager.requestWhenInUseAuthorization()            //Will request permission
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
       // post()
    
     //   self.mapView.removeAnnotation(annotation)
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        post(location: location!)
        

        databaseRef.child("Locations").observeSingleEvent(of: .value, with: { snapshot in   //Observing for Location change event
            
            //In swift3 its difficult to parse ArrayList.So, we have to use NSDict for first ArrayList and then again use Dict for next child.
            
            if snapshot.value is NSNull {
                
            }else {
                let snapDic = snapshot.value as? NSDictionary
                for child in snapDic! {
                let childDic = child.value as? NSDictionary
                let email = childDic?["Email"] as! String
                let lat = childDic?["Latitude"] as! NSNumber
                let lon = childDic?["Longitude"] as! NSNumber
                let lastTime = childDic?["Timestamp"] as! NSNumber
                let Time:Double = Double(lastTime) * 1000
                //print("Email:\(email) & Location: \(lat) + \(lon)")
                   
                let dateString = NSDate(timeIntervalSince1970: TimeInterval(Time))
               // print(String(describing: dateString))
                
               // var testVar: Int = 0
               //let annotation = MKPointAnnotation()
                let tmpAnnotation = MKPointAnnotation()
                    
                /*self.annotation.title = email
                let dateTime = String(describing: lastTime)
                self.annotation.subtitle = "Last Updated: "+dateTime
                self.annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
                //print(self.mapView.annotations.description)
                self.mapView.addAnnotation(self.annotation)
                */
                if (email != FIRAuth.auth()?.currentUser?.email){       // Checking if its current user or not
                    self.mapView.removeAnnotation(tmpAnnotation)
                    tmpAnnotation.title = email
                    let dateTime = String(describing: lastTime)
                    tmpAnnotation.subtitle = "Last Updated: "+dateTime
                    //annotation other than current user
                    tmpAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
                  //Code for removing
                    if self.annotationCount.index(forKey: email) == nil {
                        self.annotationCount[email] = tmpAnnotation
                    }
                    else {
                        self.mapView.removeAnnotation(self.annotationCount[email]!)         //remove annotation if its already there.It will check with email
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
    
    //For posting Data to Firebase
    func post(location : CLLocation) {
        
        mapView.removeAnnotation(annotation)
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let currentUser = FIRAuth.auth()?.currentUser
        let currentEmail = currentUser?.email
        let currentUid = currentUser?.uid
        let Timestamp = NSDate().timeIntervalSince1970*1000
      
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        print("\(date)")
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

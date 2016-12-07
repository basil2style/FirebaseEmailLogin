//
//  ViewController.swift
//  EmailLogin
//
//  Created by Basil on 2016-11-17.
//  Copyright © 2016 Makeinfo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func CreateAccount(_ sender: Any) {
        
        FIRAuth.auth()?.createUser(withEmail: Username.text!, password: Password.text!, completion: {
            user,error in
            
            if error != nil {
                
                let user = ["Email":user?.email! as Any ] as [String : Any]
                
                let databaseRef = FIRDatabase.database().reference().child("User")
                let childRef = databaseRef.childByAutoId()
                
                //databaseRef.child("Users/").childByAutoId().setValue(user)
                childRef.updateChildValues(user)
 
                self.login()
             
                self.performSegue(withIdentifier:"ToMapList", sender: nil)
            }
            else {
                print("User Created")
                self.login()
            }
        })
    }
    
       func login(){
        
        FIRAuth.auth()?.signIn(withEmail: Username.text!, password: Password.text!, completion: {
            (user,error) in
            
            if error != nil {
                print ("Incorrect")
            }
            else {
                print("User Loggined")
   //             let address = self.getCoordinate()
     //           print("Latitude \(address.lat) & Longitude \(address.lon)")
                
                
                
                self.performSegue(withIdentifier:"ToMapList", sender: nil)
            }
            
        })
    }
    

}

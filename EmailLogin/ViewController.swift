//
//  ViewController.swift
//  EmailLogin
//
//  Created by Basil on 2016-11-17.
//  Copyright © 2016 Makeinfo. All rights reserved.
//

import UIKit
import Firebase

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
                self.login()
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
            }
            
        })
    }

}

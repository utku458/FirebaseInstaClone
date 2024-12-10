//
//  ViewController.swift
//  FirebaseInstaClone
//
//  Created by Utku Altınay on 25.10.2024.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if (emailText.text != ""  && passwordText.text != "" ){
           
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (auth, error) in
                
                if (error != nil){
                    
                    self.AlertMaker(title: "ERROR!", message: error?.localizedDescription ?? "error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        
        else{
            AlertMaker(title: "Error", message: "Email / Password ?")
        }
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if (emailText.text != ""  && passwordText.text != "" ){
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (auth , error) in
                if (error != nil){
                    
                    self.AlertMaker(title: "ERROR!", message: error?.localizedDescription ?? "error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            AlertMaker(title: "Error", message: "Email / Password ?")
        }
        
        
        
    }
    
    
    func AlertMaker(title:String , message:String){
        
    let alert =  UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
        
        
    }
    
}


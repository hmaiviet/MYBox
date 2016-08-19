//
//  ViewController.swift
//  myBox
//
//  Created by VietHung on 7/29/16.
//  Copyright © 2016 VietHung. All rights reserved.
//

import UIKit
import Firebase
import OneDriveSDK

class ViewController: UIViewController, UITextFieldDelegate, DBRestClientDelegate {



    
    @IBOutlet weak var tf_user: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    var restClient = DBRestClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        restClient = DBRestClient.init(session: DBSession.sharedSession())
        restClient.delegate = self
        tf_user.delegate = self
        tf_password.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDidLinkNotification:", name: "didLinkToDropboxAccountNotification", object: nil)
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    
    func restClient(client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!, metadata: DBMetadata!) {
        NSLog("File uploaded successfully to path: %@", metadata.path);
    }
    
    func restClient(client: DBRestClient!, loadedMetadata metadata: DBMetadata!) {
        if(metadata.isDirectory){
            NSLog("Folder '%@' contains:", metadata.path);
            for file in metadata.contents{
                NSLog(String(file.filename));
            }
        }
    }
    
    func restClient(client: DBRestClient!, loadMetadataFailedWithError error: NSError!) {
        NSLog("Error loading metadata: %@", error);
    }
    
    
    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        NSLog("File upload failed with error: %@", error);

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func didPressLink() {
        if((DBSession.sharedSession()).isLinked()){
            DBSession.sharedSession().linkFromController(self)
        }
    }
    func handleDidLinkNotification(notification: NSNotification) {
//        self.testUpload()
        
//        self.restClient.loadMetadata("/")
        
        let VHome = self.storyboard?.instantiateViewControllerWithIdentifier("viewHome") as! VCHome
        navigationController?.pushViewController(VHome, animated: true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        
        
        if let username = tf_user.text, let password = tf_password.text{
            if username == "" || password == ""{
                print("Username and password are required")
            }
            else{
                FIRAuth.auth()?.signInWithEmail(username, password: password, completion: {
                    (user: FIRUser?, error: NSError?) in
                    if error != nil{
                        print("Couldn't sign in: \(error)")
                    }
                    else{
                        if !DBSession.sharedSession().isLinked() {
                            print("Working")
                            DBSession.sharedSession().linkFromController(self)
                            
                        }
                        else {
                            print("Working2")
                            DBSession.sharedSession().linkFromController(self)
                            //            print("Connect")
                        }
                        print("Successfully signed in, user email: \(user?.email)")

//                        self.testUpload()
                    }
                })
            }
        }
        return true
    }

}


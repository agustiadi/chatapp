//
//  ProfilePicViewController.swift
//  ChatApp
//
//  Created by Agustiadi on 1/2/15.
//  Copyright (c) 2015 Agustiadi. All rights reserved.
//

import UIKit

class ProfilePicViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var imagePickedBoolean = false
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    @IBOutlet weak var profilePicture: UIImageView!

    @IBAction func openPhotoLibrary(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        imagePickedBoolean = true
        
        presentViewController(image, animated: true, completion: nil)

    }
    
    @IBAction func saveProfilePic(sender: AnyObject) {
        
        if imagePickedBoolean == false {
            
            displayAlert("No Image Selected", message: "You will need to select an image to post")
            
        } else {
            
            //Spinner Activity Indicator. Do not forget to initialize it and put a stop activity when its done.
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(self.view.center.x-25, self.view.center.y-110, 50, 50))
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if PFUser.currentUser() != nil {
                var currentUser = PFUser.currentUser()
                let imageData = UIImagePNGRepresentation(self.profilePicture.image)
                let imageFile = PFFile(name: "\(PFUser.currentUser().username).png", data: imageData)
                currentUser["profilePic"] = imageFile as PFFile
                currentUser.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError!) -> Void in
                    
                    if success == false {
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        self.displayAlert("Sign-Up Error", message: "There is an error while trying to save your profile picture. Please try again!")
                        
                    } else {
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        self.performSegueWithIdentifier("userTable2", sender: self)

                    }
                })
    
            } else {
                println("User is not logged in")
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Making the Profile Picture ImageView as Circle
        profilePicture.layer.cornerRadius = profilePicture.bounds.width/2
        profilePicture.clipsToBounds = true
        
        //reset the page
        imagePickedBoolean = false
        profilePicture.image = UIImage(named: "placeholder.png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function that controls the Image Picker Controller
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        profilePicture.image = image
        imagePickedBoolean = true
    }

    
    // Function that calls the various UIAlert
    func displayAlert(title: String, message: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

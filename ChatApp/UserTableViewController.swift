//
//  UserTableViewController.swift
//  ChatApp
//
//  Created by Agustiadi on 1/2/15.
//  Copyright (c) 2015 Agustiadi. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    var name = [String]()
    var email = [String]()
    var image = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userQuery = PFQuery(className: "_User")
        userQuery.findObjectsInBackgroundWithBlock({
            (users: [AnyObject]!, error: NSError!) -> Void in
            
            self.image.removeAll(keepCapacity: true)
            self.name.removeAll(keepCapacity: true)
            
            if error == nil {
                
                for user in users {
                    
                    if user.email != PFUser.currentUser().email {
                        self.name.append(user.username)
                        self.email.append(user.email)
                        self.image.append(user["profilePic"] as PFFile)
                    }

                }
                self.tableView.reloadData()
            } else {
                println(error)
            }

        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return name.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UserTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UserTableViewCell

        cell.profileName.text = name[indexPath.row]
        
        // Extracting UIImage from PFFile
        let imageFile = image[indexPath.row]
        imageFile.getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                let image = UIImage(data: imageData)
                cell.profileImage.image = image
            }else {
                println(error)
            }
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as UserTableViewCell
        otherName = name[indexPath.row]
        otherEmail = email[indexPath.row]
        self.performSegueWithIdentifier("chatRoom", sender: self)
    }
    
    
    @IBAction func logoutCurrentUser(sender: AnyObject) {
        
        PFUser.logOut()
        println("You have been succesfully logged out!")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

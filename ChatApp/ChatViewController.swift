//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Agustiadi on 2/2/15.
//  Copyright (c) 2015 Agustiadi. All rights reserved.
//

import UIKit

var otherName: String = ""
var otherEmail: String = ""

class ChatViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var chatScrollView: UIScrollView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var textMessageView: UITextView!
    
    @IBOutlet weak var sendBtnLbl: UIButton!
    @IBAction func sendMessageBtn(sender: AnyObject) {
    }
    
    var scrollViewOriginalY: CGFloat = 0
    var frameMessageOriginalY: CGFloat = 0
    
    var messageX: CGFloat = 37.0
    var messageY: CGFloat = 26.0
    
    var senderArray = [String]()
    var messageArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let theWidth = self.view.frame.width
        let theHeight = self.view.frame.height
        
        let placeholderMsg = UILabel(frame: CGRectMake(5, 6, 200, 20))
        
        //UI Elements Set-up
        self.title = otherName
        
        chatScrollView.frame = CGRectMake(0, 64, theWidth, theHeight-114)
        chatScrollView.layer.zPosition = 20
        frameMessageView.frame = CGRectMake(0, chatScrollView.frame.maxY, theWidth, 50)
        lineLabel.frame = CGRectMake(0, 0, theWidth, 1)
        frameMessageView.addSubview(lineLabel)
        textMessageView.frame = CGRectMake(2, 0, self.frameMessageView.frame.width-52, 48)
        sendBtnLbl.center = CGPointMake(frameMessageView.frame.width-30, 24)
        
        scrollViewOriginalY = self.chatScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        
        placeholderMsg.text = "Type a message ....."
        placeholderMsg.backgroundColor = UIColor.clearColor()
        placeholderMsg.textColor = UIColor.lightGrayColor()
        textMessageView.addSubview(placeholderMsg)
        
        refreshResult()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshResult(){
        
        let theWidth = self.view.frame.width
        let theHeight = self.view.frame.height
        
        messageX = 37.0
        messageY = 26.0
        
        messageArray.removeAll(keepCapacity: false)
        senderArray.removeAll(keepCapacity: false)
        
        let innerP1 = NSPredicate(format: "sender = %@ AND other = %@", PFUser.currentUser().email, otherEmail)
        let innerQ1: PFQuery = PFQuery(className: "Messages", predicate: innerP1)
        
        let innerP2 = NSPredicate(format: "sender = %@ AND other = %@", otherEmail, PFUser.currentUser().email)
        let innerQ2: PFQuery = PFQuery(className: "Messages", predicate: innerP2)
        
        var query = PFQuery.orQueryWithSubqueries([innerQ1, innerQ2])
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil{
                
                for object in objects {
                    self.senderArray.append(object["sender"] as String)
                    self.messageArray.append(object["message"] as String)
                }
                
            }else {
                println(error)
            }
        })
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

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
var myImg: UIImage? = UIImage()
var otherImg: UIImage? = UIImage()


class ChatViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {

    
    @IBOutlet weak var chatScrollView: UIScrollView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var textMessageView: UITextView!
    @IBOutlet weak var sendBtnLbl: UIButton!
    
    var scrollViewOriginalY: CGFloat = 0
    var frameMessageOriginalY: CGFloat = 0
    
    let placeholderMsg = UILabel(frame: CGRectMake(5, 6, 200, 20))
    
    var messageX: CGFloat = 40.0
    var messageY: CGFloat = 26.0
    var frameX: CGFloat = 35.0
    var frameY: CGFloat = 21.0
    var imageX: CGFloat = 3.0
    var imageY: CGFloat = 3.0
    
    var senderArray = [String]()
    var messageArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for subview in self.chatScrollView.subviews {
            subview.removeFromSuperview()
        }
        
        var refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        
        let theWidth = self.view.frame.width
        let theHeight = self.view.frame.height
        
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
        
        self.navigationItem.setRightBarButtonItem(refreshButton, animated: false)
        
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewGesture.numberOfTapsRequired = 1
        chatScrollView.addGestureRecognizer(tapScrollViewGesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        for subView in self.chatScrollView.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func didTapScrollView() {
        
        self.view.endEditing(true)
    }
    
    func textViewDidChange(textView: UITextView) {
        
        
        if textMessageView.hasText() == false {
            
            self.placeholderMsg.hidden = false
            
        } else {
            
            self.placeholderMsg.hidden = true
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if textMessageView.hasText() == false {
            
            self.placeholderMsg.hidden = false
        }
    }
    
    func keyboardWasShown(notification: NSNotification){
        
        let dict: NSDictionary = notification.userInfo!
        let s: NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        let rect: CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            
            self.chatScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY - rect.height
            
            var bottomOffset: CGPoint = CGPointMake(0, self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height)
            self.chatScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished: Bool) in
        })
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        let dict: NSDictionary = notification.userInfo!
        let s: NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        let rect: CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            
            self.chatScrollView.frame.origin.y = self.scrollViewOriginalY
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY
            
            var bottomOffset: CGPoint = CGPointMake(0, self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height)
            self.chatScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished: Bool) in
        })
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        scrollViewOriginalY = self.chatScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        
        refreshResult()
        
    }
    
    func refresh(){

        refreshResult()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshResult(){
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        messageX = 40.0
        messageY = 26.0
        frameX = 35.0
        frameY = 21.0
        imageX = 3.0
        imageY = 3.0
        
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
                
                for subview in self.chatScrollView.subviews {
                    subview.removeFromSuperview()
                }
                
                for var i=0; i <= self.senderArray.count-1; i++ {
                    
                    if self.senderArray[i] == PFUser.currentUser().email{
                        
                        var messageLbl = UILabel(frame: CGRectMake(0, 0, self.chatScrollView.frame.width-94, CGFloat.max))
                        messageLbl.backgroundColor = UIColor.clearColor()
                        messageLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.Left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.whiteColor()
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = self.chatScrollView.frame.size.width - self.messageX - messageLbl.frame.size.width
                        messageLbl.frame.origin.y = self.messageY
                        self.chatScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        var frameLbl: UILabel = UILabel()
                        frameLbl.frame.size = CGSizeMake(messageLbl.frame.width+10, messageLbl.frame.height+10)
                        frameLbl.frame.origin.x = self.chatScrollView.frame.size.width - self.frameX - frameLbl.frame.size.width
                        frameLbl.frame.origin.y = self.frameY
                        frameLbl.backgroundColor = UIColor.greenColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.chatScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        var img: UIImageView = UIImageView()
                        img.image = UIImage(named: "mickey")
                        img.frame.size = CGSizeMake(34, 34)
                        img.frame.origin.x = self.chatScrollView.frame.size.width - self.imageX - img.frame.size.width
                        img.frame.origin.y = self.imageY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.width/2
                        img.clipsToBounds = true
                        img.image = myImg
                        self.chatScrollView.addSubview(img)
                        self.imageY += frameLbl.frame.size.height + 20
                        
                        self.chatScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                        
                    } else {
                        
                        var messageLbl = UILabel(frame: CGRectMake(0, 0, self.chatScrollView.frame.width-94, CGFloat.max))
                        messageLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        messageLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.Left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.blackColor()
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = self.messageX
                        messageLbl.frame.origin.y = self.messageY
                        self.chatScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        var frameLbl: UILabel = UILabel()
                        frameLbl.frame = CGRectMake(self.frameX, self.frameY, messageLbl.frame.size.width + 10, messageLbl.frame.size.height + 10)
                        frameLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.chatScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        var img: UIImageView = UIImageView()
                        img.image = UIImage(named: "mickey")
                        img.frame = CGRectMake(self.imageX, self.imageY, 34, 34)
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.width/2
                        img.clipsToBounds = true
                        img.image = otherImg
                        self.chatScrollView.addSubview(img)
                        self.imageY += frameLbl.frame.size.height + 20
                        
                        self.chatScrollView.contentSize = CGSizeMake(theWidth, self.messageY)

                    }
                    
                    var bottomOffset: CGPoint = CGPointMake(0, self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height)
                    self.chatScrollView.setContentOffset(bottomOffset, animated: false)
                    
                
                }
                
            }else {
                println(error)
            }
        })
    }
    
    @IBAction func sendMessageBtn(sender: AnyObject) {

        
        if textMessageView.text == "" {
            println("no text")
        } else {
            
            var messageDBTable = PFObject(className: "Messages")
            messageDBTable["sender"] = PFUser.currentUser().email
            messageDBTable["other"] = otherEmail
            messageDBTable["message"] = textMessageView.text
            messageDBTable.saveInBackgroundWithBlock({
                (success: Bool!, error: NSError!) -> Void in
                
                if success == true {
                    println("message sent")
                    self.textMessageView.text = ""
                    self.placeholderMsg.hidden = false
                    self.refreshResult()
                } else {
                    println(error)
                }
            })
        }
        
        self.view.endEditing(true)
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

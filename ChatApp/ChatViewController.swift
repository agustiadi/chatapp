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
    var frameX: CGFloat = 32.0
    var frameY: CGFloat = 21.0
    var imageX: CGFloat = 3.0
    var imageY: CGFloat = 3.0
    
    var senderArray = [String]()
    var messageArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
    
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
        
        self.navigationItem.setRightBarButtonItem(refreshButton, animated: false)

    }
    
    override func viewDidAppear(animated: Bool) {
        
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
        
        let theWidth = self.view.frame.width
        let theHeight = self.view.frame.height
        
        messageX = 37.0
        messageY = 26.0
        frameX = 32.0
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
                
                for subView in self.chatScrollView.subviews {
                    subView.removeFromSuperview()
                }
                
                for var i=0; i <= self.senderArray.count-1; i++ {
                    
                    if self.senderArray[i] == PFUser.currentUser().email{
                        
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
                        messageLbl.frame.origin.x = self.chatScrollView.frame.width - self.messageX - messageLbl.frame.size.width
                        messageLbl.frame.origin.y = self.messageY
                        self.chatScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.height + 30
                        
                        var frameLbl: UILabel = UILabel()
                        frameLbl.frame.size = CGSizeMake(messageLbl.frame.width+10, messageLbl.frame.height+10)
                        frameLbl.frame.origin.x = self.chatScrollView.frame.width - self.frameX - frameLbl.frame.size.width
                        frameLbl.frame.origin.y = self.frameY
                        frameLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.chatScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.height + 20
                        
                        var img: UIImageView = UIImageView()
                        img.image = UIImage(named: "mickey")
                        img.frame.size = CGSizeMake(34, 34)
                        img.frame.origin.x = self.chatScrollView.frame.width - self.imageX - img.frame.width
                        img.frame.origin.y = self.imageY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.width/2
                        img.clipsToBounds = true
                        img.image = myImg
                        self.chatScrollView.addSubview(img)
                        self.imageY += frameLbl.frame.height + 20
                        
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
                        self.messageY += messageLbl.frame.height + 30
                        
                        var frameLbl: UILabel = UILabel()
                        frameLbl.frame = CGRectMake(self.frameX, self.frameY, messageLbl.frame.width + 10, messageLbl.frame.height + 10)
                        frameLbl.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.chatScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.height + 20
                        
                        var img: UIImageView = UIImageView()
                        img.image = UIImage(named: "mickey")
                        img.frame = CGRectMake(self.imageX, self.imageY, 34, 34)
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.width/2
                        img.clipsToBounds = true
                        img.image = otherImg
                        self.chatScrollView.addSubview(img)
                        self.imageY += frameLbl.frame.height + 20
                        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

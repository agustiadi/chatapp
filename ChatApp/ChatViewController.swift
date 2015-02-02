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

class ChatViewController: UIViewController {

    @IBOutlet weak var chatScrollView: UIScrollView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var textMessageView: UITextView!
    
    @IBOutlet weak var sendBtnLbl: UIButton!
    @IBAction func sendMessageBtn(sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let theWidth = self.view.frame.width
        let theHeight = self.view.frame.height
        
        var scrollViewOriginalY: CGFloat = 0
        var frameMessageOriginalY: CGFloat = 0
        
        let placeholderMsg = UILabel(frame: CGRectMake(5, 6, 200, 20))

        // Do any additional setup after loading the view.
        
        //UI Elements Set-up
        self.title = otherName
        
        chatScrollView.frame = CGRectMake(0, 64, theWidth, theHeight-114)
        chatScrollView.layer.zPosition = 20
        frameMessageView.frame = CGRectMake(0, chatScrollView.frame.maxY, theWidth, 50)
        lineLabel.frame = CGRectMake(0, 0, theWidth, 1)
        textMessageView.frame = CGRectMake(2, 0, self.frameMessageView.frame.width-52, 48)
        sendBtnLbl.center = CGPointMake(frameMessageView.frame.width-30, 24)
        
        scrollViewOriginalY = self.chatScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        
        placeholderMsg.text = "Type a message ....."
        textMessageView.addSubview(placeholderMsg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

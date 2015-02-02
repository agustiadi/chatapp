//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Agustiadi on 2/2/15.
//  Copyright (c) 2015 Agustiadi. All rights reserved.
//

import UIKit

var chattingWith: String = ""

class ChatViewController: UIViewController {
    @IBOutlet weak var chatWithLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        chatWithLabel.text = "Hi \(PFUser.currentUser().username), you are chatting with \(chattingWith)"
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

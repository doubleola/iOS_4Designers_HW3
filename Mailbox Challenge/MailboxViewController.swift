//
//  MailboxViewController.swift
//  Mailbox Challenge
//
//  Created by Olawale Oladunni on 10/26/15.
//  Copyright © 2015 walmartlabs. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    
    @IBOutlet weak var mailboxScrollView: UIScrollView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!
    
    
    var initialCenter = CGPoint!()
    var messageMovedLeftMoreThan60 = Bool(true)
    var backgroundColor = CGFloat!()
    var initialRightIconCenter = CGPoint(x: 0, y: 0)
    var initialLeftIconCenter = CGPoint (x:0, y:0)
    var initialFeedCenter = CGPoint (x:0, y:0)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mailboxScrollView.contentSize = CGSize(width: 320, height: 1367)
        rescheduleImageView.alpha = 0
        listImageView.alpha = 0
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        mailboxScrollView.addGestureRecognizer(edgeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanMessage(sender: UIPanGestureRecognizer) {
        
        let location = sender.locationInView(view)
        let translation = sender.translationInView(view)
//        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {print ("you started panning, so I'm setting the icons to be grayed out, I'm starting the animation to darken them, and I'm setting the initial centers of the message and both icons to be equal to where they were when you started panning.")
            
            leftIconImageView.alpha = 0.5
            rightIconImageView.alpha = 0.5
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                }, completion: { (Bool) -> Void in print("you completed animation")
            })
                
            initialCenter = messageImageView.center
            initialRightIconCenter = rightIconImageView.center
            initialLeftIconCenter = leftIconImageView.center
            initialFeedCenter = feedImageView.center
        }
            
        else if sender.state == UIGestureRecognizerState.Changed {print("You didn't stop panning, so I'm now going to be moving the center of the Message along with your finger. Also, whenever the location of your finger is far left enough, I'm going to change the color to yellow and make the icon start following you. The location of your finger is now: \(location) and the location of the center of the Message is now: \(messageImageView.center).")
            
            messageImageView.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)
            
            if messageImageView.center.x <= -100 {print("the message center is at or below -100, so I'm going to change the color to BROWN and and change the icon and make the icon start following and set a variable for brown and set a variable saying it was in the go zone.")
                
                leftIconImageView.alpha = 0
                
                backgroundView.backgroundColor = UIColor(red: 204/255, green: 149/255, blue: 97/255, alpha: 1)
                
                rightIconImageView.image = UIImage(named: "list_icon")
                
                rightIconImageView.center.x = CGFloat(initialRightIconCenter.x + translation.x + 60)
                
                messageMovedLeftMoreThan60 = Bool(true)
                
                backgroundColor = 2
                
            }
            else if messageImageView.center.x <= 100 {print("the message center is between -100 and 100, so I'm going to change the color to YELLOW and make the icon start following and change the icon and set a variable for yellow and set a variable saying it was in the go zone.")
                
                leftIconImageView.alpha = 0
                
                backgroundView.backgroundColor = UIColor(red: 248/255, green: 204/255, blue: 40/255, alpha: 1)
                
                rightIconImageView.image = UIImage(named: "later_icon")
                
                rightIconImageView.center.x = CGFloat(initialRightIconCenter.x + translation.x + 60)
                
                messageMovedLeftMoreThan60 = Bool(true)
                
                backgroundColor = 1
                
            }
                
            else if messageImageView.center.x <= 220 {print("the message center is between 100 and 220, so undo the yellow and brown etc stuff.")
                
                backgroundView.backgroundColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
                
                rightIconImageView.center.x = CGFloat(initialRightIconCenter.x)
                
                leftIconImageView.center.x = CGFloat(initialLeftIconCenter.x)
                
                messageMovedLeftMoreThan60 = Bool(false)
                
                
            }
                
            else if messageImageView.center.x <= 420 {print ("the message center is between 220 and 420, so so I'm going to change the color to GREEN and make the icon start following and set a variable for green and set a variable saying it was in the go zone.")
                
                rightIconImageView.alpha = 0
                
                backgroundView.backgroundColor = UIColor(red: 98/255, green: 213/255, blue: 80/255, alpha: 1)
                
                leftIconImageView.image = UIImage(named: "archive_icon")
                
                leftIconImageView.center.x = CGFloat(initialLeftIconCenter.x + translation.x - 60)
                
                messageMovedLeftMoreThan60 = Bool(true)
                
                backgroundColor = 3
                
            }
            
            else if messageImageView.center.x > 420 {print ("the message center is between 220 and 420, so so I'm going to change the color to RED 237 83 41 and make the icon start following and set a variable for red and set a variable saying it was in the go zone.")
                
                rightIconImageView.alpha = 0
                
                backgroundView.backgroundColor = UIColor(red: 237/255, green: 83/255, blue: 41/255, alpha: 1)
                
                leftIconImageView.image = UIImage(named: "delete_icon")
                
                leftIconImageView.center.x = CGFloat(initialLeftIconCenter.x + translation.x - 60)
                
                messageMovedLeftMoreThan60 = Bool(true)
                
                backgroundColor = 4
                
                }
            }
        
            else if sender.state == UIGestureRecognizerState.Ended {print("(PROBLEM?) You lifted your finger")
            
            if messageMovedLeftMoreThan60 == false {messageImageView.center = initialCenter}
                
            else if backgroundColor == 1.0 {print("released while yellow so now need to remove the left icon, continue animating the message to the left until it goes off screen, and fade out the right icon, and then fade in the schedule screen")
                
                //hide the left icon - don't need it
                self.leftIconImageView.alpha = 0
                
                //animate moving the message all the way to the left and fading out the right icon
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageImageView.center.x = -160
                    self.rightIconImageView.alpha = 0
                })
                
                //add a delay, then fade in schedule screen
                UIView.animateWithDuration(0.4, delay: 0.4, options: [], animations: { () -> Void in
                    self.rescheduleImageView.alpha = 1
                    }, completion: { (Bool) -> Void in []
                })
                
            }
            
            else if backgroundColor == 2.0 {print("released while brown so now need to remove the left icon, continue animating the message to the left until it goes off screen, and fade out the right icon, and then fade in the list screen")
                
                self.leftIconImageView.alpha = 0
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageImageView.center.x = -160
                    self.rightIconImageView.alpha = 0
                })
                
                UIView.animateWithDuration(0.4, delay: 0.4, options: [], animations: { () -> Void in
                    self.listImageView.alpha = 1
                    }, completion: { (Bool) -> Void in []
                })
                
            }
            
            else if backgroundColor == 3.0 {print ("released while green so now need to remove the right icon, continue animating the message to the right until it goes off screen, and fade out the left icon, and then remove the entire green message")
                
                self.rightIconImageView.alpha = 0
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageImageView.center.x = 480
                    self.leftIconImageView.alpha = 0
                    }) { (Bool)  -> Void in UIView.animateWithDuration(0.4, animations: { () -> Void in
                        self.feedImageView.center.y = self.initialFeedCenter.y - 86
                    })
                }
            }
            
            else if backgroundColor == 4.0 {print ("released while red so now need to remove the right icon, continue animating the message to the right until it goes off screen, and fade out the left icon, and then remove the entire red message")
                
                self.rightIconImageView.alpha = 0
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageImageView.center.x = 480
                    self.leftIconImageView.alpha = 0
                    }) { (Bool)  -> Void in
                        
                        UIView.animateWithDuration(0.4, animations: { () -> Void in
                            self.feedImageView.center.y = self.initialFeedCenter.y - 86
                        })
                }
            }
        }

    }
    
    @IBAction func onTapReschedule(sender: UITapGestureRecognizer) {
      
        print (" You tapped the origin-yellow rescheduler screen so I'm going to hide (dismiss) the reschedule screen, then animate hiding the message from below, moving the feed up over it, then bringing the message image back to center, and then revealing the container by moving the feed back down below it.")
        
        //dismiss the rescheduler overlay
        rescheduleImageView.alpha = 0
        
        //animate the feed moving up. since it's layered in front of the message container view, the yellow disappears.
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.feedImageView.center.y = self.initialFeedCenter.y - 86
            }){ (Bool) -> Void in
                [self.messageImageView.center.x = self.initialCenter.x,self.rightIconImageView.center.x = CGFloat(self.initialRightIconCenter.x), self.rightIconImageView.alpha = 1,
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.feedImageView.center.y = self.initialFeedCenter.y
                    })
                ]
        }
        
        leftIconImageView.center.x = CGFloat(initialLeftIconCenter.x)
        rightIconImageView.center.x = CGFloat(initialLeftIconCenter.x)
        
    }
    
    @IBAction func onTapList(sender: UITapGestureRecognizer) {
     
        print ("You tapped the origin-brown list screen so I'm going to hide the list screen, then animate hiding the message from below, moving the feed up over it, then bringing the message image back to center, and then revealing the container by moving the feed back down below it.")
        
        listImageView.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.feedImageView.center.y = self.initialFeedCenter.y - 86
            }) { (Bool) -> Void in
                [self.messageImageView.center.x = self.initialCenter.x,
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.feedImageView.center.y = self.initialFeedCenter.y
                    })
                ]
            }
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



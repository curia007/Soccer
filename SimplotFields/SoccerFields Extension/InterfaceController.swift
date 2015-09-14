//
//  InterfaceController.swift
//  SoccerFields Extension
//
//  Created by Carmelo I. Uria on 9/11/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import WatchKit
import Foundation

import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate
{

    @IBOutlet var mapInterface: WKInterfaceMap!
    
    private var session:WCSession? = nil
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        if (context == nil)
        {
            if (WCSession.isSupported() == true)
            {
                self.session = WCSession.defaultSession()
                self.session?.delegate = self
                self.session?.activateSession()
            }
        }
    }

    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate()
    {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    //MARK: - Action functions
    
    @IBAction func hapticAction()
    {
        let deviceInterface: WKInterfaceDevice = WKInterfaceDevice.currentDevice()
        deviceInterface.playHaptic(.Notification)
    }
    
    //MARK: - WKSessionDelegate functions
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject])
    {
        
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject])
    {
        debugPrint("\(__FUNCTION__):  userInfo: \(userInfo)")
    }
}

//
//  InterfaceController.swift
//  SoccerFields Extension
//
//  Created by Carmelo I. Uria on 9/11/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController
{

    @IBOutlet var mapInterface: WKInterfaceMap!
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
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
}

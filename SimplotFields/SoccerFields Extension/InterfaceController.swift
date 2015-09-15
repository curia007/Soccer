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
        
        if (userInfo.count > 0)
        {
            let latitude: CLLocationDegrees? = userInfo["LATITUDE"] as? CLLocationDegrees
            let longitude: CLLocationDegrees? = userInfo["LONGITUDE"]as? CLLocationDegrees
            
            if (latitude != nil)
            {
                
                if (longitude != nil)
                {
                    let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                    self.mapInterface.addAnnotation(coordinate, withPinColor: .Green)
                    
                    let mapPoint: MKMapPoint = MKMapPointForCoordinate(coordinate)
                    let mapRect: MKMapRect = MKMapRectMake(mapPoint.x, mapPoint.x, 50.0, 50.0)
                    self.mapInterface.setVisibleMapRect(mapRect)
                    
                    let span: MKCoordinateSpan = MKCoordinateSpanMake(0.10, 0.10)
                    let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
                    self.mapInterface.setRegion(region)
                }
            }
        }
    }
        
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject])
    {
        debugPrint("\(__FUNCTION__):  message: \(message)")
    }
    
    func sessionReachabilityDidChange(session: WCSession)
    {
        debugPrint("\(__FUNCTION__):  session reachability did change")
    }

}

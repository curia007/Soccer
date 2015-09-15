//
//  TodayViewController.swift
//  Soccer Today
//
//  Created by Carmelo I. Uria on 9/14/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit
import QuartzCore

import NotificationCenter

import MapKit
import CoreLocation

import EventKit

import FieldsFramework

class TodayViewController: UIViewController, NCWidgetProviding
{
        
    @IBOutlet weak var mapView: MKMapView!
    
    private let operationQueue:NSOperationQueue = NSOperationQueue()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.mapView.layer.cornerRadius = 50.0
        
        NSNotificationCenter.defaultCenter().addObserverForName("EVENT_CALENDAR_NOTIFICATION", object: nil, queue: operationQueue) { (notification) -> Void in
            
            let events:[EKEvent]! = (notification.userInfo!["events" as NSString]) as! [EKEvent]
            
            let event: EKEvent = events.first!
            
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            let usLocale: NSLocale = NSLocale(localeIdentifier: "en_US")
            dateFormatter.locale = usLocale
            
            //var description: String = " match @ \(dateFormatter.stringFromDate(event.startDate))"
            var description: String = ""
            
            if (event.notes != nil)
            {
                description = description + event.notes!
            }
            
            let components: [String] = description.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            description = components.joinWithSeparator("")

            let address: String = event.location!
            
            let geocoder: CLGeocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemark, error) -> Void in
                
            })
        }

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - NCWidgetProviding methods
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void))
    {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }

    func widgetMarginInsetsForProposedMarginInsets(var defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets
    {
        defaultMarginInsets.bottom = 10.0
        return defaultMarginInsets
    }
}

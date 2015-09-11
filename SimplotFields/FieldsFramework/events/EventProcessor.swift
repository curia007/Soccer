//
//  EventProcessor.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/8/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import EventKit

public class EventProcessor
{
    let eventStore: EKEventStore = EKEventStore()
    
    public var events: [EKEvent] = []
    
    public init (days: Int)
    {
        self.eventStore.requestAccessToEntityType(.Event) { (granted, error) -> Void in
            
            if (error == nil)
            {
                if (granted == true)
                {
                    
                    //let defaultCalendar: EKCalendar = self.eventStore.calendarsForEntityType(EKEntityType.Event)
                    
                    // Get the appropriate calendar
                    let calendar: NSCalendar? = NSCalendar.currentCalendar()

                    //let calendars: [EKCalendar] = Array<EKCalendar>(arrayLiteral: defaultCalendar)
                    let calendars: [EKCalendar] = self.eventStore.calendarsForEntityType(EKEntityType.Event)
                    
                    // Create the start and end date components
                    let startDate: NSDate = NSDate()
                    
                    let endDate: NSDate = calendar!.dateByAddingUnit([.Day], value: days, toDate: startDate, options: [])!
                    
                    // Create the predicate from the event store's instance method
                    let predicate: NSPredicate = self.eventStore.predicateForEventsWithStartDate(startDate,
                        endDate: endDate, calendars: calendars)
                    
                    let events: [EKEvent] = self.eventStore.eventsMatchingPredicate(predicate)

                    self.events = events
                    
                    if (events.count > 0)
                    {
                        let userInformation: [NSObject: AnyObject] = ["events" : events]
                        let eventNotification: NSNotification = NSNotification(name: "EVENT_CALENDAR_NOTIFICATION", object: self, userInfo: userInformation)
                        NSNotificationCenter.defaultCenter().postNotification(eventNotification)
                    }
                }
            }

        }
        
     }
    
    public class func retrieveEvents(entityType: EKEntityType, completionHandler: EKEventStoreRequestAccessCompletionHandler)
    {
        let eventStore: EKEventStore = EKEventStore()
        eventStore.requestAccessToEntityType(entityType, completion: completionHandler)
            
        
    }
}

//
//  EventProcessor.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/8/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import EventKit

public class EventProcessor: NSObject
{
    let eventStore: EKEventStore = EKEventStore()
    
    private let webView: UIWebView = {
        let frame: CGRect = CGRectMake(0.0, 0.0, 300.0, 300.0)
        return UIWebView(frame: frame)
    }()
    
    private var downloadTask:NSURLSessionDataTask?
    
    public func retrieveEvents (days: Int)
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
    
    public func testWithWebView(URL: NSURL)
    {
        UIApplication.sharedApplication().openURL(URL)
    }
    
    public func retrieveEventsFromURL(url: NSURL, completionHandler: (() -> Void))
    {
        let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        self.downloadTask =  session.dataTaskWithURL(url) { (data, response, error) -> Void in
         
            self.processCalendar(data!, completionHandler: completionHandler)
        }
        
        self.downloadTask!.resume()
    }

    // MARK: - private methods
    
    private func processCalendar(data: NSData, completionHandler: (() -> Void))
    {
        let dataString: String = String(data: data, encoding: NSUTF8StringEncoding)!
        
        self.processCalendarString(dataString)
        
        completionHandler()
    }
    
    private func processCalendarString(string: String)
    {
        var lines: [String] = string.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        
        lines = verify(lines)
        
        let calendars: [AnyObject] = self.extractCalendar(lines)
        
        // add Calendar to EventBook and set user defaults
        
    }
    
    private func verify(lines: [String]) -> [String]
    {
        let count: Int = lines.count
        var newLines: [String] = []
        
        for (var i = 0; i < count; i++)
        {
            var line: String = lines[i]
            
            if (line.characters.first == " ")
            {
                line = String(line.characters.dropFirst())
                let newString: String = newLines[newLines.count - 1] + line
                newLines[newLines.count - 1] = newString
            }
            else
            {
                newLines.append(line)
            }
        }
        
        return newLines
    }
    
    private func extractCalendar(lines: [String]) -> [AnyObject]
    {
     
        var calendarDictionary: [String : AnyObject] = [:]
        var calendar: [String] = []
        var calendars: [AnyObject] = []
        var events: [AnyObject] = []
        
        var timeZone: [String : AnyObject] = [:]
        
        var addingCalendar: Bool = false
        
        for (var i = 0; i < lines.count; i++)
        {
            let line:String = lines[i]
            
            if (line == "BEGIN:VCALENDAR")
            {
                addingCalendar = true
            }
            else if (line == "END:VCALENDAR")
            {
                addingCalendar = false
                
                timeZone = self.extractTimeZone(lines)
                events = self.extractEvents(calendar)
                
                calendarDictionary["timezone"] = timeZone
                calendarDictionary["events"] = events
                calendarDictionary["lines"] = calendar
                
                calendars.append(calendarDictionary)
                
                calendarDictionary = [:]
                calendar = []
            }
            else
            {
                if (addingCalendar == true)
                {
                    calendar.append(line)
                }
            }
        }
        
        return calendars
    }
    
    private func extractDaylight(lines: [String]) -> [String : String]
    {
        var daylight: [String : String] = [:]
        var newLines: [String] = []
        
        var isEditing: Bool = false
        
        for (var i = 0; i < lines.count; i++)
        {
            let line: String = lines[i]
            
            if (line == "BEGIN:DAYLIGHT")
            {
                isEditing = true
            }
            else if (line == "END:DAYLIGHT")
            {
                for (var n = 0; n < newLines.count; n++)
                {
                    let components: [String] = newLines[n].componentsSeparatedByString(":")
                    daylight[components[0]] = components[1]
                }
                
                isEditing = false
            }
            else
            {
                if (isEditing == true)
                {
                    newLines.append(line)
                }
                
            }
        }
        
        return daylight
    }
    
    private func extractStandard(lines: [String]) -> [String : String]
    {
        var standard: [String : String] = [:]
        var newLines: [String] = []
        
        var isEditing: Bool = false
        
        for (var i = 0; i < lines.count; i++)
        {
            let line: String = lines[i]
            
            if (line == "BEGIN:STANDARD")
            {
                isEditing = true
            }
            else if (line == "END:STANDARD")
            {
                for (var n = 0; n < newLines.count; n++)
                {
                    let components: [String] = newLines[n].componentsSeparatedByString(":")
                    standard[components[0]] = components[1]
                }

                isEditing = false
            }
            else
            {
                if (isEditing == true)
                {
                    newLines.append(line)
                }
                
            }
        }
        
        return standard
        
    }
    
    private func extractTimeZone(lines: [String]) -> [String : AnyObject]
    {
        var timeZone: [String : AnyObject] = [:]
        var timeZoneLines: [String] = []
        var daylightDictionary: [String : String]
        var standardDictionary: [String : String]
        
        var isEditing: Bool = false
        
        for (var i = 0; i < lines.count; i++)
        {
            let line: String = lines[i]
            
            if (line == "BEGIN:VTIMEZONE")
            {
                isEditing = true
            }
            else if (line == "END:VTIMEZONE")
            {
                isEditing = false
                daylightDictionary = self.extractDaylight(timeZoneLines)
                standardDictionary = self.extractStandard(timeZoneLines)
                
                timeZone["DAYLIGHT"] = daylightDictionary
                timeZone["STANDARD"] = standardDictionary
            }
            else
            {
                if (isEditing == true)
                {
                    timeZoneLines.append(line)
                }
            }
        }
        
        return timeZone
    }
    
    private func extractEvents(lines: [String]) -> [AnyObject]
    {
        var eventDictionary: [String : String] = [:]
        var events: [AnyObject] = []

        var addingEvent: Bool = false

        for (var i = 0; i < lines.count; i++)
        {
            let line:String = lines[i]
            
            if (line == "BEGIN:VEVENT")
            {
                addingEvent = true
            }
            else if (line == "END:VEVENT")
            {
                addingEvent = false
                
                events.append(eventDictionary)
            }
            else
            {
                if (addingEvent == true)
                {
                    let components: [String] = line.componentsSeparatedByString(":")
                    
                    if (components[0] == "DESCRIPTION")
                    {
                        let count: Int = components.count
                        var value: String = ""
                        
                        for( var i = 1; i < count; i++)
                        {
                            value = value + components[i]
                        }
                        
                        eventDictionary[components[0]] = value
                    }
                    else
                    {
                        if (components.count == 2)
                        {
                            eventDictionary[components[0]] = components[1]
                        }
                        else
                        {
                            print("\(__FUNCTION__): Error in parsing .ics file")
                        }
                    }
                        
               }
            }
        }
        
        return events
    }
    
    // MARK: - static methdos
    
    public class func retrieveEvents(entityType: EKEntityType, completionHandler: EKEventStoreRequestAccessCompletionHandler)
    {
        let eventStore: EKEventStore = EKEventStore()
        eventStore.requestAccessToEntityType(entityType, completion: completionHandler)
    }    
}

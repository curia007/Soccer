//
//  MapViewController.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/1/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation

import EventKit

import WatchConnectivity

import FieldsFramework

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, WCSessionDelegate
{

    @IBOutlet weak var mapView: MKMapView!
  
    private let fieldLocations: [String : String] = {
     
        // Initial load of field positions
        let filePath = NSBundle.mainBundle().pathForResource("FieldLocations", ofType: "plist")
        return NSDictionary(contentsOfFile: filePath!) as! [String : String]
    }()

    private let operationQueue:NSOperationQueue = NSOperationQueue()
    
    private let locationManager:CLLocationManager = CLLocationManager()
    
    private var isInitialLocation: Bool = true
    
    private var session: WCSession? = nil
    private var sessionUserInfoTransfer: WCSessionUserInfoTransfer? = nil
    
    private var routes: [MKRoute]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.delegate = self
        
        // retrieve babysitter location
        let authorizationStatus:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if ((authorizationStatus == .Denied) ||
            (authorizationStatus == .Restricted) ||
            (authorizationStatus == .NotDetermined))
            
        {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        // handle map span
        let park: Field = Field("Simplot")
        
        let overlay: FieldMapOverlay = FieldMapOverlay(park)
        
        self.mapView.addOverlay(overlay)

        // establish session to watch
        if (WCSession.isSupported() == true)
        {
            self.session = WCSession.defaultSession()
            self.session?.delegate = self
            self.session?.activateSession()
        }
        
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

            // setup local notification
            
            let localNotification: UILocalNotification = UILocalNotification()
            
            let calendar: NSCalendar = NSCalendar.currentCalendar()
            let calendarUnits: NSCalendarUnit = [.Month, .Day,  .Year]
            
            let dateComponents: NSDateComponents = calendar.components(calendarUnits, fromDate: event.startDate)
            
            dateComponents.day = dateComponents.day - 1
            
            let notificationDate: NSDate = calendar.dateFromComponents(dateComponents)!
            
            localNotification.alertTitle = event.title
            localNotification.alertBody = "Next Match"
            localNotification.category = "Nationals"
            localNotification.alertLaunchImage = "nationals"

            localNotification.fireDate = notificationDate

            self.addFieldAnnotation(event.location!, match: event.title, description: description)
            

        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - private functions
    
    private func addFieldAnnotation(fieldName: String, match: String, description: String)
    {
        let stringCoordinates: String? = self.fieldLocations[fieldName]
        
        if stringCoordinates == nil
        {
            // use geocode to get coordinates
            let geocoder: CLGeocoder = CLGeocoder()
            geocoder.geocodeAddressString(fieldName, completionHandler: { (placemarks, error) -> Void in
             if (error == nil)
             {
                debugPrint("\(__FUNCTION__): getting coordinates for \(fieldName) placemark: \(placemarks)")
                
                if (placemarks?.count > 0)
                {
                    let placemark: CLPlacemark = (placemarks?.first)!
                    let destinationAnnotation: DestinationAnnotation = DestinationAnnotation((placemark.location?.coordinate)!, title: match, subtitle: description, information: description)

                    self.mapView.addAnnotation(destinationAnnotation)
                    self.retrieveDirections((placemark.location?.coordinate)!)
                    
                    // send event to watch
                    let latitude: CLLocationDegrees = (placemark.location?.coordinate.latitude)!
                    let longitude: CLLocationDegrees = (placemark.location?.coordinate.longitude)!
                    let fieldInformation: [String : AnyObject] = ["NAME" : fieldName, "MATCH" : match, "DESCRIPTION" : description, "LATITUDE" : latitude, "LONGITUDE" : longitude]
                    
                    let paired: Bool = (self.session?.paired)!
                    
                    if (paired == true)
                    {
                        if (self.session?.watchAppInstalled == true)
                        {
                            if (self.session?.reachable == true)
                            {
                                self.sessionUserInfoTransfer = self.session?.transferUserInfo(fieldInformation)
                            }
                        }
                    }
                    
                }
                
                return
            }
                print("\(__FUNCTION__): error:: \(error) ")
            })
            
            return
        }
        
        let fieldPoint = CGPointFromString(stringCoordinates!)
        let fieldCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(fieldPoint.x), CLLocationDegrees(fieldPoint.y))

        // send event to watch
        let fieldInformation: [String : AnyObject] = ["LOCATION" : fieldCoordinate as! AnyObject, "NAME" : fieldName, "MATCH" : match, "DESCRIPTION" : description]
        
        let paired: Bool = (self.session?.paired)!
        
        if (paired == true)
        {
            if (self.session?.watchAppInstalled == true)
            {
                self.session?.transferUserInfo(fieldInformation)
            }
        }

        self.session?.transferUserInfo(fieldInformation)
        
        let fieldAnnotation: FieldAnnotation = FieldAnnotation(fieldCoordinate, title: match, subtitle: description, fieldName: fieldName )
        
        self.mapView.addAnnotation(fieldAnnotation)
        self.retrieveDirections(fieldCoordinate)
        
    }
    
    private func loadGameInformation()
    {
        let eventProcessor: EventProcessor = EventProcessor()
        eventProcessor.retrieveEvents(14)
        debugPrint("\(__FUNCTION__):  eventProcessor: \(eventProcessor)")
    }

    private func retrieveDirections(coordinate: CLLocationCoordinate2D)
    {
        let directionProcessor:DirectionProcessor =  DirectionProcessor()
        let directions: MKDirections = directionProcessor.retrieveDirections(self.mapView.userLocation.coordinate, destinationLocation: coordinate, transportType: MKDirectionsTransportType.Automobile)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            
            if (error == nil)
            {
                debugPrint("\(__FUNCTION__):  response: \(response)")
                
                self.routes = response?.routes
                
                if (self.routes != nil)
                {
                    for route in self.routes!
                    {
                        let line: MKPolyline = route.polyline
                        self.mapView.addOverlay(line)
                        
                        debugPrint("\(__FUNCTION__): Route Name: \(route.name)")
                        debugPrint("\(__FUNCTION__): Total Distance (in Meters) : \(route.distance)")
                        
                        let steps: [MKRouteStep] = route.steps
                        
                        debugPrint("\(__FUNCTION__): Total steps: \(steps.count)")
                        
                        for step in steps
                        {
                            debugPrint("\(__FUNCTION__): Route instructions: \(step.instructions)")
                            debugPrint("\(__FUNCTION__): Route distance: \(step.distance)")
                        }
                    }
                }
            }
            else
            {
                print("\(__FUNCTION__):  error: \(error)")
            }
        }
    }
    
    // MARK: - MKMapViewDelegate functions

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation)
    {
        if (self.isInitialLocation == true)
        {
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            
            self.mapView.setRegion(region, animated: true)
            
            // load game information
            self.loadGameInformation()

            self.isInitialLocation = false
        }
    }
    
    func mapView(mapView: MKMapView, didAddOverlayRenderers renderers: [MKOverlayRenderer])
    {
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
        if overlay is FieldMapOverlay
        {
            let fieldImage: UIImage = UIImage(named: "simplot_complex_map")!
            let field:Field = Field("Simplot")
            let overlay: FieldMapOverlay = FieldMapOverlay(field)
            
            return FieldMapOverlayRenderer(overlay, image: fieldImage)
        }
        else if overlay is MKPolyline
        {
            // draw the track
            let polyLine = overlay
            let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
            polyLineRenderer.strokeColor = UIColor.blueColor()
            polyLineRenderer.lineWidth = 2.0
            
            return polyLineRenderer
        }
        
        return MKOverlayRenderer()
    }

    //MARK: - WCSessionDelegate functions
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject])
    {
        debugPrint("\(__FUNCTION__)")
    }
    
    func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: NSError?)
    {
        debugPrint("\(__FUNCTION__):  error: \(error)  userInfoTranser: \(userInfoTransfer)")
    }
    func session(session: WCSession, didFinishFileTransfer fileTransfer: WCSessionFileTransfer, error: NSError?)
    {
        debugPrint("\(__FUNCTION__):  error: \(error)")
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


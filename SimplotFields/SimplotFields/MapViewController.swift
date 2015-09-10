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

import FieldsFramework

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{

    @IBOutlet weak var mapView: MKMapView!
  
    private let fieldLocations: [String : String] = {
     
        // Initial load of field positions
        let filePath = NSBundle.mainBundle().pathForResource("FieldLocations", ofType: "plist")
        return NSDictionary(contentsOfFile: filePath!) as! [String : String]
    }()

    private let operationQueue:NSOperationQueue = NSOperationQueue()
    
    private let locationManager:CLLocationManager = CLLocationManager()
    
    private var fieldCoordinate: CLLocationCoordinate2D?
    
    private var isInitialLocation: Bool = true
    
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

        
        NSNotificationCenter.defaultCenter().addObserverForName("EVENT_CALENDAR_NOTIFICATION", object: nil, queue: operationQueue) { (notification) -> Void in
            
            let events:[EKEvent]! = (notification.userInfo!["events" as NSString]) as! [EKEvent]
            
            let event: EKEvent = events.first!
            
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            let usLocale: NSLocale = NSLocale(localeIdentifier: "en_US")
            dateFormatter.locale = usLocale
            
            let description: String = " at \(dateFormatter.stringFromDate(event.startDate))"
            
            self.addFieldAnnotation(event.location!, match: event.title, description: description)
            
            let directionProcessor:DirectionProcessor =  DirectionProcessor()
            let directions: MKDirections = directionProcessor.retrieveDirections(self.mapView.userLocation.coordinate, destinationLocation: self.fieldCoordinate!, transportType: MKDirectionsTransportType.Automobile)
            
            directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
                
                if (error == nil)
                {
                    debugPrint("\(__FUNCTION__):  response: \(response)")
                    
                    let routes: [MKRoute]? = response?.routes
                    
                    if (routes != nil)
                    {
                        for route in routes!
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
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - private functions
    
    private func addFieldAnnotation(fieldName: String, match: String, description: String)
    {
        let stringCoordinates: String = self.fieldLocations[fieldName]!
        
        let fieldPoint = CGPointFromString(stringCoordinates)
        
        self.fieldCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(fieldPoint.x), CLLocationDegrees(fieldPoint.y))
        
        let fieldAnnotation: FieldAnnotation = FieldAnnotation(self.fieldCoordinate!, title: match, subtitle: description, fieldName: fieldName )
        
        self.mapView.addAnnotation(fieldAnnotation)
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func loadGameInformation()
    {
        let eventProcessor: EventProcessor = EventProcessor(days: 14)
        debugPrint("\(__FUNCTION__):  eventProcessor: \(eventProcessor)")
    }

    // MARK: - MKMapViewDelegate functions

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation)
    {
        if (self.isInitialLocation == true)
        {
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            
            //self.mapView.setRegion(region, animated: true)
            
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

}


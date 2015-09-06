//
//  DirectionProcessor.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/6/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import MapKit

public class DirectionProcessor: NSObject
{
    
    public func retrieveDirections(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D, transportType: MKDirectionsTransportType, map: MKMapView)
    {
        let sourceAddressDictionary: [String : AnyObject] = [:]
        
        let source: MKPlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: sourceAddressDictionary)
        let sourceMapItem: MKMapItem = MKMapItem(placemark: source)
        
        sourceMapItem.name = ""
        
        let destinationAddressDictionary: [String : AnyObject] = [:]
        
        let destination: MKPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: destinationAddressDictionary)
        let destinationMapItem: MKMapItem = MKMapItem(placemark: destination)
        destinationMapItem.name = ""
        
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = transportType
        
        let directions: MKDirections = MKDirections(request: request)
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
                        map.addOverlay(line)
                        
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

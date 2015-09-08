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
    
    public func retrieveDirections(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D, transportType: MKDirectionsTransportType) -> MKDirections
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
     
        return directions
    }

}

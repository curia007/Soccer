//
//  FieldMapOverlay.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/2/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import MapKit

public class FieldMapOverlay: NSObject, MKOverlay
{
    public var coordinate: CLLocationCoordinate2D
    public var boundingMapRect: MKMapRect
    
    init(_ field: Field)
    {
        self.coordinate = field.midCoordinate!
        self.boundingMapRect = field.overlayBoundingMapRect!
    }
}

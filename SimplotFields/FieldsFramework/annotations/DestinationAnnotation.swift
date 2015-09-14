//
//  DestinationAnnotation.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/14/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import MapKit

public class DestinationAnnotation: NSObject, MKAnnotation
{
    public var title: String?
    public var subtitle: String?
    
    public var information: String
    
    public var coordinate: CLLocationCoordinate2D
    
    public init(_ coordinate: CLLocationCoordinate2D, title: String, subtitle: String, information: String)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.information = information
    }

}

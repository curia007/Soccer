//
//  FieldAnnotation.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/3/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import MapKit

public class FieldAnnotation: NSObject, MKAnnotation
{
    public var title: String?
    public var subtitle: String?
    
    public var fieldName: String

    public var coordinate: CLLocationCoordinate2D

    public init(_ coordinate: CLLocationCoordinate2D, title: String, subtitle: String, fieldName: String)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle + ":  " + fieldName
        self.fieldName = fieldName
    }
}

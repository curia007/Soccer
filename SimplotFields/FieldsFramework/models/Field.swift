//
//  Field.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/2/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import MapKit

public class Field
{
    public var boundary: [CLLocationCoordinate2D]
    public var boundaryPointsCount: NSInteger
    
    public var midCoordinate: CLLocationCoordinate2D
    public var overlayTopLeftCoordinate: CLLocationCoordinate2D
    public var overlayTopRightCoordinate: CLLocationCoordinate2D
    public var overlayBottomLeftCoordinate: CLLocationCoordinate2D
    public var overlayBottomRightCoordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(overlayBottomLeftCoordinate.latitude,
                overlayTopRightCoordinate.longitude)
        }
    }
    
    public var overlayBoundingMapRect: MKMapRect {
        get {
            let topLeft = MKMapPointForCoordinate(overlayTopLeftCoordinate);
            let topRight = MKMapPointForCoordinate(overlayTopRightCoordinate);
            let bottomLeft = MKMapPointForCoordinate(overlayBottomLeftCoordinate);
            
            return MKMapRectMake(topLeft.x,
                topLeft.y,
                fabs(topLeft.x-topRight.x),
                fabs(topLeft.y - bottomLeft.y))
        }
    }
    
    var name: String?
    
    public init(_ filename: String)
    {
        let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: "plist")
        let properties = NSDictionary(contentsOfFile: filePath!)
        
        let midPoint = CGPointFromString(properties!["midCoordinate"] as! String)
        midCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(midPoint.x), CLLocationDegrees(midPoint.y))
        
        let overlayTopLeftPoint = CGPointFromString(properties!["overlayTopLeftCoordinate"] as! String)
        overlayTopLeftCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(overlayTopLeftPoint.x),
            CLLocationDegrees(overlayTopLeftPoint.y))
        
        let overlayTopRightPoint = CGPointFromString(properties!["overlayTopRightCoordinate"] as! String)
        overlayTopRightCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(overlayTopRightPoint.x),
            CLLocationDegrees(overlayTopRightPoint.y))
        
        let overlayBottomLeftPoint = CGPointFromString(properties!["overlayBottomLeftCoordinate"] as! String)
        overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(overlayBottomLeftPoint.x),
            CLLocationDegrees(overlayBottomLeftPoint.y))
        
        let boundaryPoints = properties!["boundary"] as! NSArray
        
        boundaryPointsCount = boundaryPoints.count
        
        boundary = []
        
        for i in 0...boundaryPointsCount-1 {
            let p = CGPointFromString(boundaryPoints[i] as! String)
            boundary += [CLLocationCoordinate2DMake(CLLocationDegrees(p.x), CLLocationDegrees(p.y))]
        }
    }
    
}



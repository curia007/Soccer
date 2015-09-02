//
//  Field.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/2/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import CoreLocation
import MapKit

public class Field
{
    public let midCoordinate: CLLocationCoordinate2D?
    public let overlayTopLeftCoordinate: CLLocationCoordinate2D?
    public let overlayTopRightCoordinate: CLLocationCoordinate2D?
    public let overlayBottomLeftCoordinate: CLLocationCoordinate2D?
    public let overlayBottomRightCoordinate: CLLocationCoordinate2D?
    
    let boundary: [CLLocationCoordinate2D]?
    let boundaryPointCount: Int
    
    public var overlayBoundingMapRect: MKMapRect?
    
    public init (_ filename: String)
    {
        let filePath: String? = NSBundle.mainBundle().pathForResource(filename, ofType: "plist")
        
        if (filePath != nil)
        {
            debugPrint("\(__FUNCTION__):  filePath = \(filePath)")
        
            let properties: NSDictionary! = NSDictionary(contentsOfFile: filePath!)
            
            var point: CGPoint = CGPointFromString(properties["midCoordinate"] as! String)
            
            var x: NSNumber = NSNumber(float: Float(point.x))
            var y: NSNumber = NSNumber(float: Float(point.y))
            
            self.midCoordinate = CLLocationCoordinate2DMake(x.doubleValue, y.doubleValue)
            
            point = CGPointFromString(properties["overlayTopLeftCoordate"] as! String)
            
            x = NSNumber(float: Float(point.x))
            y = NSNumber(float: Float(point.y))
            
            self.overlayTopLeftCoordinate = CLLocationCoordinate2DMake(x.doubleValue, y.doubleValue)
            
            point = CGPointFromString(properties["overlayTopRigthCoordate"] as! String)
            
            x = NSNumber(float: Float(point.x))
            y = NSNumber(float: Float(point.y))
            
            self.overlayTopRightCoordinate = CLLocationCoordinate2DMake(x.doubleValue, y.doubleValue)
            
            point = CGPointFromString(properties["overlayBottomLeftCoordate"] as! String)
            
            x = NSNumber(float: Float(point.x))
            y = NSNumber(float: Float(point.y))
            
            self.overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(x.doubleValue, y.doubleValue)
            
            point = CGPointFromString(properties["overlayBottomRightCoordate"] as! String)
            
            x = NSNumber(float: Float(point.x))
            y = NSNumber(float: Float(point.y))
            
            self.overlayBottomRightCoordinate = CLLocationCoordinate2DMake(x.doubleValue, y.doubleValue)
            
            self.boundary = nil

            let boundaryPoints:[String] = properties["boundary"] as! [String]
            self.boundaryPointCount = boundaryPoints.count
            
            for (var i:Int = 0; i < self.boundaryPointCount; i++)
            {
                let p: CGPoint = CGPointFromString(boundaryPoints[i])
                let pX: NSNumber = NSNumber(float: Float(p.x))
                let pY: NSNumber = NSNumber(float: Float(p.y))
                
                self.boundary?.append(CLLocationCoordinate2DMake(pX.doubleValue, pY.doubleValue))

            }
            
            self.overlayBoundingMapRect = {
                let topLeft: MKMapPoint = MKMapPointForCoordinate(self.overlayBottomLeftCoordinate!)
                let topRight: MKMapPoint = MKMapPointForCoordinate(self.overlayTopRightCoordinate!)
                let bottomLeft: MKMapPoint = MKMapPointForCoordinate(self.overlayBottomLeftCoordinate!)
                
                return MKMapRectMake(topLeft.x, topLeft.y, fabs(topLeft.x - topRight.x), fabs(topLeft.y - bottomLeft.y))
            }()
            
            return
        }
        
        self.midCoordinate = nil
        self.overlayTopLeftCoordinate = nil
        self.overlayTopRightCoordinate = nil
        self.overlayBottomLeftCoordinate = nil
        self.overlayBottomRightCoordinate = nil
        
        self.boundary = nil
        self.boundaryPointCount = 0
        
        self.overlayBoundingMapRect = nil
    }

}

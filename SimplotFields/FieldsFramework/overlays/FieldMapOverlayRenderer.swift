//
//  FieldMapOverlayView.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/2/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import MapKit

public class FieldMapOverlayRenderer: MKOverlayRenderer
{
    let overlayImage: UIImage?
    
    public init(_ overlay: MKOverlay, image: UIImage)
    {
        self.overlayImage = image
        super.init(overlay: overlay)
    }
    
    public override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext)
    {
        let imageReference: CGImageRef = (self.overlayImage?.CGImage)!
        let mapRect: MKMapRect = self.overlay.boundingMapRect
        let rect:CGRect = self.rectForMapRect(mapRect)
        
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0.0, -rect.size.height)
        CGContextDrawImage(context, rect, imageReference)
        
    }
}

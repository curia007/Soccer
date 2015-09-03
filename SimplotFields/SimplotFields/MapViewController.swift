//
//  MapViewController.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/1/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import MapKit

import FieldsFramework

class MapViewController: UIViewController, MKMapViewDelegate
{

    @IBOutlet weak var mapView: MKMapView!
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // TEST
        let park: Field = Field("Simplot")
        
        let latDelta = park.overlayTopLeftCoordinate.latitude -
            park.overlayBottomRightCoordinate.latitude + 0.05
        
        // think of a span as a tv size, measure from one corner to another
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        
        let region = MKCoordinateRegionMake(park.midCoordinate, span)
        
        self.mapView.region = region
        
        let overlay: FieldMapOverlay = FieldMapOverlay(park)
        
        self.mapView.addOverlay(overlay)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - MKMapViewDelegate functions

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
        
        return MKOverlayRenderer()
    }

}


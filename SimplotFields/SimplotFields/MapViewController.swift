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
    
    private let fieldMapOverlayRenderer: FieldMapOverlayRenderer = {
    
        let fieldImage: UIImage = UIImage(named: "simplot_complex_map")!
        
        let field:Field = Field("MagicMountain")
        
        let overlay: FieldMapOverlay = FieldMapOverlay(field)
        
        return FieldMapOverlayRenderer(overlay, image: fieldImage)
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // TEST
        let park: Field = Field("MagicMountain")
        
        ///let latDelta = park.overlayTopLeftCoordinate.latitude -
            park.overlayBottomRightCoordinate.latitude
        
        // think of a span as a tv size, measure from one corner to another
        //let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        
        //let region = MKCoordinateRegionMake(park.midCoordinate, span)
        
        //mapView.region = region

        
        self.mapView.addOverlay(self.fieldMapOverlayRenderer.overlay as! FieldMapOverlay)
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
            let field:Field = Field("MagicMountain")
            let overlay: FieldMapOverlay = FieldMapOverlay(field)
            
            return FieldMapOverlayRenderer(overlay, image: fieldImage)
        }
        
        return MKOverlayRenderer()
    }

}


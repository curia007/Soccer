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
        //let simplotField: Field = Field("Simplot")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - MKMapViewDelegate functions
/*
    func mapView(mapView: MKMapView, viewForOverlay overlay: MKOverlay) -> MKOverlayView
    {
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        
    }
*/
}


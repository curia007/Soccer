//
//  MapViewController.swift
//  SimplotFields
//
//  Created by Carmelo I. Uria on 9/1/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation

import FieldsFramework

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{

    @IBOutlet weak var mapView: MKMapView!
  
    private let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.delegate = self
        
        // retrieve babysitter location
        let authorizationStatus:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if ((authorizationStatus == .Denied) ||
            (authorizationStatus == .Restricted) ||
            (authorizationStatus == .NotDetermined))
            
        {
            self.locationManager.requestAlwaysAuthorization()
        }

        
        
        let park: Field = Field("Simplot")
        
        // handle map span
       
        let overlay: FieldMapOverlay = FieldMapOverlay(park)
        
        self.mapView.addOverlay(overlay)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - MKMapViewDelegate functions

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation)
    {
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        
        self.mapView.region = region
    }
    
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


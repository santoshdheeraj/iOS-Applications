//
//  File.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 11/3/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ItemViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var resItem = RestaurantDetailItem()
    
    override func viewDidLoad() {
        
        resItem.ref = FIRDatabase.database().reference()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        fillDetails()
    }
    
    // When view is loaded fill the item fields
    func fillDetails(){
        
        if let mapView = self.mapView
        {
            mapView.delegate = self
        }
        mapView.setRegion(resItem.itemregion!, animated: true)
        
        resItem.itemannotation = CoffeeAnnotation(title: resItem.venue.name, subtitle: resItem.venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(resItem.venue.latitude), longitude: Double(resItem.venue.longitude)))
        
        mapView.addAnnotation(resItem.itemannotation!)
        
        navigationItem.title = resItem.venue.name
        
        nameLabel.attributedText = resItem.setIcons(0, labeltext: resItem.venue.name)
        
        addressLabel.text = resItem.venue.address
        
        resItem .distance = String(format: "%.2f",((resItem.venue.distancetolocation)/resItem.miles)) + " mi"
        
        distanceLabel.attributedText = resItem.setIcons(1, labeltext: resItem.distance)
        
        resItem.latitude = String(resItem.itemannotation!.coordinate.latitude)
        
        resItem.longitude = String(resItem.itemannotation!.coordinate.longitude)
        
    }
    
    // Add annotation to Map
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation.isKindOfClass(MKUserLocation)
        {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationIdentifier")
        
        if view == nil
        {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
        }
        
        view?.canShowCallout = true
        
        return view
    }
    
    
    // Add Check-In for this Location
    @IBAction func checkIn(sender: AnyObject) {
        
        self.resItem.dateTime = self.resItem.dateFormatter.stringFromDate(NSDate())
        
        let title = "CheckIn At"
        let message = "\(resItem.venue.name)"
        let fbItem = FirbaseItem(us: (FIRAuth.auth()?.currentUser)!)
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Yes",
                                         style: .Destructive,
                                         handler: {_ in
                                            fbItem.writetoCheckIn(self.resItem.dateTime, values:["place": self.resItem.venue.name, "lat": self.resItem.latitude!, "long": self.resItem.longitude!, "address": self.resItem.venue.address])
        })
        ac.addAction(deleteAction)
        
        presentViewController(ac, animated: true, completion: nil)
        
    }
    
    
}
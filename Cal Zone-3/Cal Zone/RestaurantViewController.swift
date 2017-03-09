//
//  FirstViewController.swift
//  Cal Zone
//
//  Created by Rahul Maddineni on 10/28/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class RestaurantViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var mapView:MKMapView?
    
    @IBOutlet var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set contentInset for tableView
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView!.contentInset = insets
        tableView!.estimatedRowHeight = 65
        navigationItem.title = "NearBy Restaurants"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RestaurantViewController.onVenuesUpdated(_:)), name: API.notifications.venuesUpdated, object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let tableView = self.tableView
        {
            tableView.delegate = self
            tableView.dataSource = self
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var rItem = RestaurantItem()
    
    // Instantiate Location Manger
    override func viewDidAppear(animated: Bool)
    {
        if rItem.locationManager == nil {
            rItem.locationManager = CLLocationManager()
            
            rItem.locationManager!.delegate = self
            rItem.locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            rItem.locationManager!.requestAlwaysAuthorization()
            rItem.locationManager!.distanceFilter = 50 // Don't send location updates with a distance smaller than 50 meters between them
            rItem.locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
            
            refreshVenues(newLocation, getDataFromFoursquare: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rItem.venues?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1 
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        cell.updateLabels() //sets the fonts of the labels
        
        if let venue = rItem.venues?[indexPath.row]
        {
            cell.nameLabel?.text = venue.name
            
            rItem.distance = String(format: "%.2f",((venue.distancetolocation)/rItem.miles))

            cell.distanceLabel?.text = rItem.distance + " mi"
            
        }
        
        return cell
    }

    // pass item details to item controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "itemSegue" {
        
            let destinationVC = segue.destinationViewController as! ItemViewController
        
            if let indexPath = self.tableView!.indexPathForSelectedRow{
                
                let selectedRow =  rItem.venues![indexPath.row]
                print(selectedRow)
                destinationVC.resItem.venue = selectedRow
                rItem.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Double(selectedRow.latitude), longitude: Double(selectedRow.longitude)), rItem.distanceSpan/5, rItem.distanceSpan/5)
                destinationVC.resItem.itemregion = rItem.region
                destinationVC.resItem.itemannotation = rItem.annotation
            }
        }
        if segue.identifier == "profileSegue" {

        }
    }
    
    // update venues by distance change
    func refreshVenues(location: CLLocation?, getDataFromFoursquare:Bool = false)
    {
        if location != nil
        {
            rItem.lastLocation = location
        }
        
        if let location = rItem.lastLocation
        {
            if getDataFromFoursquare == true
            {
                FSAPI.sharedInstance.getRestaurantsWithLocation(location)
            }
            
            let (start, stop) = calculateCoordinatesWithRegion(location)
            
            let predicate = NSPredicate(format: "latitude < %f AND latitude > %f AND longitude > %f AND longitude < %f", start.latitude, stop.latitude, start.longitude, stop.longitude)
            
            let realm = try! Realm()
            
            rItem.venues = realm.objects(Venue).filter(predicate).sort {
                location.distanceFromLocation($0.coordinate) < location.distanceFromLocation($1.coordinate)
            }
            
            
            for venue in rItem.venues!
            {
                rItem.annotation = CoffeeAnnotation(title: venue.name, subtitle: venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)))
            }
            
            tableView?.reloadData()
        }
    }
    
    // Get details of current location
    func calculateCoordinatesWithRegion(location:CLLocation) -> (CLLocationCoordinate2D, CLLocationCoordinate2D)
    {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, rItem.distanceSpan, rItem.distanceSpan)
        
        var start:CLLocationCoordinate2D = CLLocationCoordinate2D()
        var stop:CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        start.latitude  = region.center.latitude  + (region.span.latitudeDelta  / 2.0)
        start.longitude = region.center.longitude - (region.span.longitudeDelta / 2.0)
        stop.latitude   = region.center.latitude  - (region.span.latitudeDelta  / 2.0)
        stop.longitude  = region.center.longitude + (region.span.longitudeDelta / 2.0)
        
        return (start, stop)
    }
    
    
    func onVenuesUpdated(notification:NSNotification)
    {
        refreshVenues(nil)
    }
    
}


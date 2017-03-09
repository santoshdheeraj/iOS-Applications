//
//  mapDetailViewController.swift
//  Cal Zone
//
//  Created by Santosh Dheeraj Yelamarthi on 12/3/16.
//  Copyright © 2016 Syracuse University. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class mapDetailViewController: UIViewController, MKMapViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var itemregion : MKCoordinateRegion?
    
    var itemannotation : CoffeeAnnotation?
    
    var longitude: String = ""
    
    var latitude: String = ""
    
    var name: String = ""
    
    var address: String = ""
    
    var newPhoto : UIImage?
    
    var photoPresent: Bool = false
    
    let distanceSpan:Double = 1000
    
    var ref: FIRDatabaseReference!
    
    // var firebaseImgFound: Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    
    var itemID = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let mapView = self.mapView
        {
            mapView.delegate = self
        }
        
        itemregion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!), distanceSpan, distanceSpan)
        
        itemannotation = CoffeeAnnotation(title: name, subtitle: address, coordinate: CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!))
        
        mapView.setRegion(itemregion!, animated: true)
        
        mapView.addAnnotation(itemannotation!)
        
        navigationItem.title = name
        
        latitude = String(itemannotation!.coordinate.latitude)
        longitude = String(itemannotation!.coordinate.longitude)
        
        checkForImage()
    }
    
    func checkForImage(){
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("CheckIns").child(userID!).child(itemID).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let imageUrl = dictionary["ImageURL"] as? String{
                    self.loadImage(imageUrl)
                }
                else{
                    print("Exception in unwrapping image Url")
                }
            }
            else{
                print("Exception ")
            }
            }, withCancelBlock: nil)
    }
    
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
    
    func setIcons(icon : Int, labeltext : String)-> NSAttributedString{
        let iconsSize = CGRect(x: 0, y: -5, width: 25, height: 25)
        let emojisCollection = [UIImage(named: "Restaurant"), UIImage(named: "Location"), UIImage(named: "Address"), UIImage(named: "Phone"), UIImage(named: "baby")]
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let Attachment = NSTextAttachment()
        Attachment.image = emojisCollection[icon]
        Attachment.bounds = iconsSize
        attributedString.appendAttributedString(NSAttributedString(attachment: Attachment))
        attributedString.appendAttributedString(NSAttributedString(string: "   "))
        attributedString.appendAttributedString(NSAttributedString(string: labeltext))
        
        return attributedString
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToTimeLineViewController" {
            
            
        }
    }
    
    @IBAction func doneButton(sender: AnyObject){
      
        if(photoPresent == true)
        {
            let userID = FIRAuth.auth()?.currentUser?.uid
            let imageID: String = String(self.ref.child(userID!)) + itemID + ".png"
            let storageRef = FIRStorage.storage().reference().child(imageID)
            
            if let uploadData = UIImagePNGRepresentation(self.newPhoto!)
            {
                storageRef.putData(uploadData, metadata: nil, completion:
                    {(metadata,error) in
                        if error != nil
                        {
                            print(error)
                            return
                        }
                        else
                        {
                            
                            if let imageURL = metadata?.downloadURL()?.absoluteString
                            {
                                self.ref.child("CheckIns").child("\(userID!)/\(self.itemID)/ImageURL").setValue(imageURL)
                                let alert = UIAlertController(title: "", message: "Your photo has been added to the timeline", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                            
                        }
                        
                        
                })
            }
            else{
                
            }
        }
        else{
        }
    }
    
    @IBAction func browseImage(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Attach Image", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImage : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImage = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImage = originalImage
        }
        if let finalImage = selectedImage
        {
            newPhoto = finalImage
            photoPresent = true
        }
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    func loadImage(urlString: String){
        
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!,
                                                     completionHandler: {(data,response, error) in
                                                        
                                                        if error != nil {
                                                            print(error)
                                                            return
                                                        }
                                                        
                                                        if let dwnloadedimage = UIImage(data: data!) {
                                                            self.imageView.image = dwnloadedimage
                                                            //self.firebaseImgFound = true
                                                        }
        }).resume()
    }
    
    
}
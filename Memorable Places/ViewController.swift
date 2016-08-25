import UIKit
import CoreLocation;
import MapKit;

//TODO: Center the map when the user clicks on a location in the Root View Controller...DONE
//TODO: Deal with situation when there's nothing in the locations array...DONE
//TODO: Persist data

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    var locationManager:CLLocationManager!
    
    //viewDidLoad() fires any time a segue is made to this Map View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("LOADED");
        
        //Initialize location manager
        locationManager = CLLocationManager();
        locationManager.delegate = self;
        locationManager.requestAlwaysAuthorization();
 
        //. If there are actually places, then set the map region to the active place. The
        //  active place is the place that the user tapped on in the locations array. We can
        //  represent the active place by an index into the locations array.
        
        //. If the user tapped Show Map (which at that point, the locations array could be empty), 
        //  center the map on the user's current location. Else, let the map region center around 
        //  the location that the user tapped on in the root view controller
        
        if (locIndex != -1) {
            let location:CLLocation = CLLocation(latitude: Double(locations[locIndex]["lat"]!)!,
                                                 longitude: Double(locations[locIndex]["lon"]!)!);
            //print("In viewDidLoad before centerMap");
            centerMap(location);
        }
        else { //If locIndex is -1, user clicked on Show Map. Update map during this phase.
            locationManager.startUpdatingLocation(); //Seems that action() is called upon this line being executed
        }
        
        //Initialize gesture recognizer
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.action));
        uilpgr.minimumPressDuration = 2;
        map.addGestureRecognizer(uilpgr);
    }
    
    
    //Action for instance of a recognized gesture
    func action(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began { //On a "touch down"
            let touchPoint = gestureRecognizer.locationInView(self.map);
            let newCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: self.map);
            
            //Get lat/lon coordinate
            let touchLatitude = newCoordinate.latitude;
            let touchLongitude = newCoordinate.longitude;
            
            //Make a CLLocation from the coordinates
            let location:CLLocation = CLLocation(latitude: touchLatitude, longitude: touchLongitude);
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                
                //Begin getting name of location corresponding to coordinates
                var placeName = "";
                if let p = placemarks?[0] {
                    var subThoroughfare:String = "";
                    var thoroughfare:String = "";
                    
                    if (p.subThoroughfare != nil) {
                        subThoroughfare = p.subThoroughfare!;
                    }
                    
                    if (p.thoroughfare != nil) {
                        thoroughfare = p.thoroughfare!;
                    }
                    
                    placeName = "\(subThoroughfare) \(thoroughfare)";
                }
                
                //Update the locations array
                locations.append(["name": "\(placeName)", "lat": "\(touchLatitude)", "lon": "\(touchLongitude)"]);
                
                //Make annotation
                let annotation = MKPointAnnotation();
                annotation.coordinate = newCoordinate;
                annotation.title = placeName;
                self.map.addAnnotation(annotation);
            }
        }
        //Note that we don't wany anything to happen for a "touch up"
    }
    
    
    //--- Why is this function being called even when the user's location isn't being updated? I think because
    //    this get called when the locationManager.startUpdatingLocation() statement is executed ---
    //Allow the map to update and center on the user's physical location as it updates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //do something, e.g., center the map to the user's location as its updating
        //print("In locationManager before centerMap");
        centerMap(locations[0]);
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func centerMap(location: CLLocation) {
        let userLocation:CLLocation = location;
        let latitude = userLocation.coordinate.latitude;
        let longitude = userLocation.coordinate.longitude;
        
        let latDelta:CLLocationDegrees = 0.01;
        let lonDelta:CLLocationDegrees = 0.01;
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta);
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span);
        self.map.setRegion(region, animated: true);
        
    }
}


import UIKit
import CoreLocation;
import MapKit;

//TODO: Deal with situation when there's nothing in the locations array.
//TODO: Persist data

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    var locationManager:CLLocationManager!
    
    //viewDidLoad() fires any time a segue is made to this View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Initialize location manager
        locationManager = CLLocationManager();
        locationManager.delegate = self;
        locationManager.requestAlwaysAuthorization();
        locationManager.startUpdatingLocation();
        
        //If there are actually places, then set the map region to the active place. The
        //active place is the place that the user tapped on in the locations array. We can
        //represent the active place by an index into the locations array.
        
        //. If the array is empty, then just let the map region be a complete view of the US. 
        // Else, let the map region center around the location that the user tapped on in the 
        // root view controller
        
        if (locations.count-1 > 0) {
            //If there are actual locations, then center the map onto the appropriate region...
        }
        else {
            //locIndex must have a non-negative value. Question: Where is locIndex set?
            print("EMPTINESS!");
        }
        
        
        //Initialize gesture recognizer
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.action));
        uilpgr.minimumPressDuration = 2;
        map.addGestureRecognizer(uilpgr);
        
        //print("LOADED");
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
            
            //print(locations); //FOR TESTING
        }
        //Note that we don't wany anything to happen for a "touch up"
    }
    
    
    //Allow the map to update as the user's physical location updates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //do something, e.g., center the map to the user's location as its updating
        let userLocation:CLLocation = locations[0];
        let latitude = userLocation.coordinate.latitude;
        let longitude = userLocation.coordinate.longitude;
        
        let latDelta:CLLocationDegrees = 0.01;
        let lonDelta:CLLocationDegrees = 0.01;
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta);
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span);
        self.map.setRegion(region, animated: true);
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


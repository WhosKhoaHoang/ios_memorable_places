import UIKit

var locations = [Dictionary<String, String>()];
//Keys for a single dict are are location name, latitude, longitude. Note that I needed to initialize locations
//to something. At the outset, it has a single emtpy dictionary...Should I get rid of it when the table loads or keep it?
//Note that because this empty dict exists, indices for actual locations won't start at 0 since this empty dict occupies
//that 0th index. Rather, the indices will start at 1!!!!
var locIndex = -1;

class TableViewController: UITableViewController {
    
    //This will get called only once when the app actually starts
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Gives the number of sections in a Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //Gives the number of rows in a section of a Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count;
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        // Configure the cell...
        if locations[indexPath.row]["name"] != nil {
            cell.textLabel?.text = locations[indexPath.row]["name"];
            //Might need a dummy element in the locations array? Think: indexPath.row will exist if there are actually
            //elements inside of the locations array...
        }
        
        return cell
    }
    
    
    //This function gives us the cell that was tapped
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        locIndex = indexPath.row;
        return indexPath;
    }
    
    
    //This function is called whenever the Table View shows (e.g., from a segue)
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData();
    }

    
    //This function is called when any segue is about to take place from the Root View Controller to the Map View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "showMap") {
            locIndex = -1;
        }
    }
    
}

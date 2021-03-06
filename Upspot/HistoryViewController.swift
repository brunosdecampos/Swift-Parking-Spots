//
//  HistoryViewController.swift
//  Upspot
//
//  Created by Priscila Campos on 2017-07-21.
//  Copyright © 2017 Bruno Campos. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var spots: Array<Spot>?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Removing navigation back button
        self.navigationItem.hidesBackButton = true
        
        spots = Array<Spot>()
        
        NotificationCenter.default.addObserver(self, selector: #selector(BookingViewController.saveCoreData), name: .UIApplicationWillResignActive, object: nil)
        
        loadCoreData()
    }
    
    func loadCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spots")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results is [NSManagedObject] {
                for result in (results as! [NSManagedObject]) {
                    let type = result.value(forKey: "type") as! String
                    let address = result.value(forKey: "address") as! String
                    let image = result.value(forKey: "image") as! String
                    let time = result.value(forKey: "time") as! String
                    let weekdays = result.value(forKey: "weekdays") as! String
                    let price = result.value(forKey: "price") as! Int
                    
                    spots!.append(Spot(type: type, address: address, image: image, time: time, price: price, weekdays: weekdays))
                }
            }
        }
        catch {
            Alert.displayBasicAlert(title: "Error in saving data", message: error as! String, in: self)
        }
    }
    
    // Show Loading
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    // Hide Loading
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spots?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if spots != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCellController
            cell.feedHistoryCell(spot: (self.spots?[indexPath.row])!)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @IBAction func clearCoreData(_ sender: UIBarButtonItem) {
        CoreData.deleteCoreData(entity: "Spots")
        CoreData.deleteCoreData(entity: "Users")
        
        performSegue(withIdentifier: "CitySegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

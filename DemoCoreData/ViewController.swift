//
//  ViewController.swift
//  DemoCoreData
//
//  Created by hoangdangtrung on 2/1/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataPerson = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchingData()
    }
    
    func fetchingData() {
        // (1')
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // (6)
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        // (3')
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            self.dataPerson = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Can't fetch: \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addPerson(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add new person", message: "", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Destructive) { (action: UIAlertAction) -> Void in
            let textField = alertController.textFields?.first // Get first Element in <Array>[textFileds]
            
            self.saveName((textField?.text)!)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction) -> Void in
            
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            // Add textField to Alert
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveName(name: String) {
        
        // (1)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // (2)
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        // (3)
        person.setValue(name, forKey: "name")
        
        // (4)
        do {
            try managedContext.save()
            // (5)
            dataPerson.append(person)
        } catch let error as NSError {
            print("Can't save: \(error), \(error.userInfo)")
        }
    }
    
    // Table View DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataPerson.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let person = self.dataPerson[indexPath.row]
        
        cell.textLabel?.text = person.valueForKey("name") as? String
        
        return cell
    }
    
}


/*
Description:
(1) - Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can think of a managed object context as an in-memory “scratchpad” for working with managed objects.Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.Xcode has already generated a managed object context as part of the new project’s template – remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the application delegate. To access it, you first get a reference to the app delegate.

(2) - You create a new managed object and insert it into the managed object context. You can do this in one step with NSManagedObject’s designated initializer: init(entity:insertIntoManagedObjectContext:).You may be wondering what an NSEntityDescription is all about. Recall that earlier, I called NSManagedObject a “shape-shifter” class because it can represent any entity. An entity description is the piece that links the entity definition from your data model with an instance of NSManagedObject at runtime.

(3) - With an NSManagedObject in hand, you set the name attribute using key-value coding. You have to spell the KVC key (“name” in this case) exactly as it appears on your data model, otherwise your app will crash at runtime.

(4) - You commit your changes to person and save to disk by calling save on the managed object context. Note that save can throw an error, which is why you call it using the try keyword and within a do block.

(5) - Congratulations! Your new managed object is now safely ensconced in your Core Data persistent store. Still within the do block, insert the new managed object into the people array so that it shows up in the table view when it reloads.

(1') - As mentioned in the previous section, before you can do anything with Core Data, you need a managed object context. Fetching is no different! You pull up the application delegate and grab a reference to its managed object context.

(6) - As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data. Fetch requests are both powerful and flexible. You can use requests to fetch a set of objects that meet particular criteria (e.g., “give me all employees that live in Wisconsin and have been with the company at least three years”), individual values (e.g., “give me the longest name in the database”) and more.Fetch requests have several qualifiers that refine the set of results they return. For now, you should know that NSEntityDescription is one of these qualifiers (one that is required!).Setting a fetch request’s entity property, or alternatively initializing it with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.

(6) -
*/


























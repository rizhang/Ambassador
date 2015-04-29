//
//  ViewController.swift
//  Ambassador
//
//  Created by Richard Zhang on 4/28/15.
//  Copyright (c) 2015 Richard Zhang. All rights reserved.
//

import UIKit
import CoreData

extension UIColor{
    func getMainDarkBlueColor() -> UIColor {
        var color: UIColor = UIColor(red: CGFloat(0.176), green: CGFloat(0.243), blue: CGFloat(0.310), alpha: CGFloat(1.0))
        return color
    }
    
    func getLightBlueColor() -> UIColor {
        return UIColor(red: CGFloat(0.255), green: CGFloat(0.596), blue: CGFloat(0.820), alpha: CGFloat(1.0))
    }
    
    func getBorderOrange() -> UIColor {
        return UIColor(red: 0.976, green: 0.278, blue: 0.118, alpha: 1.00)
    }
    
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    let CELL_IDENTIFIER = "Cell"
    let SEGUE = "ManagePageSegue"

    @IBOutlet weak var tableView: UITableView!
    var titles = [String]()
    var counts = [NSNumber]()
    @IBOutlet weak var addTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var color = UIColor()
        tableView.backgroundColor = UIColor.getMainDarkBlueColor(color)()
        addTextField.layer.borderColor = UIColor.getBorderOrange(color)().CGColor
        
        if addTextField.respondsToSelector(Selector("setAttributedPlaceholder:")) {
            let color = UIColor.whiteColor()
            
            let addTitleString = "add titles..."
            
            //var range = (addTitleString as NSString).rangeOfString(addTitleString)

            var attributedString = NSMutableAttributedString(string:addTitleString)
            attributedString.addAttribute(NSForegroundColorAttributeName, value:color , range: NSMakeRange(0, count(addTitleString)))
            addTextField.attributedPlaceholder = attributedString
            
        
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        titles = self.loadCD("titleText") as! [String]
        counts = self.loadCD("visitedCount") as! [NSNumber]
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count;
    }
    
    func tableView(curTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:PagesTableViewCell = curTableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER) as! PagesTableViewCell

        let row = indexPath.row
        
        cell.titleLabel?.text = titles[row]
        cell.titleLabel.sizeToFit()
        cell.countLabel?.text = counts[row].stringValue
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(SEGUE, sender: self)

    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.deleteRow(indexPath.row)
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE {
            if let destination = segue.destinationViewController as? ManageViewController {
                if let titleIndex = tableView.indexPathForSelectedRow()?.row {
                    let title = titles[titleIndex]
                    destination.nameStr = title
                    destination.obj = self.getManagedContext(titleIndex)
                    self.incrementCount(titleIndex)
                }
            }
        }
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        NSLog("fuck yeah")
        
        saveTitle(textField.text)
        tableView.reloadData()
        textField.resignFirstResponder()
        return true;
    }
    
    //MARK: helpers
    
    func saveTitle(title: String) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Pages",
            inManagedObjectContext:
            managedContext)
        let page = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        page.setValue(title, forKey: "titleText")
        page.setValue(0, forKey: "visitedCount")

        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  
        //5
        titles.append(title)
        counts.append(0)
    }
    
    func getManagedContext() -> NSManagedObjectContext {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        return managedContext
    }
    
    func getFetchRequest(entityName:String, managedContext:NSManagedObjectContext) -> NSFetchRequest {

        let fetchRequest = NSFetchRequest(entityName:entityName)
        return fetchRequest
    }
    
    func getFetchResults() -> [NSManagedObject]? {
        let managedContext = self.getManagedContext()
        //2
        let fetchRequest = self.getFetchRequest("Pages", managedContext: managedContext)
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        return fetchedResults
    }
    
    func loadCD(type: String) -> [AnyObject] {
        
        let fetchedResults = getFetchResults()
        
        if let results = fetchedResults {
        
            if type == "titleText" {
                return getStringArray(results, type: type)
            }
            else {
                return getNumberArray(results, type: type)
            }

        }
        
        return []
    }
    
    func deleteRow(row: Int) {
        let fetchedResults = getFetchResults()
        let managedContext = self.getManagedContext()
        
        var error: NSError?
        
        if let results = fetchedResults {
            
            managedContext.deleteObject(results[row]);
            titles.removeAtIndex(row)
            counts.removeAtIndex(row)
            
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
    }
    
    func getManagedContext(row: Int) -> NSManagedObject{
        let fetchedResults = getFetchResults()
        if let results = fetchedResults {
            return results[row]
        }
        return NSManagedObject.new()
    }
    
    func getStringArray(results: [NSManagedObject], type: String) -> [String] {
        var retArr = [String]()
        
        for var i = 0; i < results.count; i++ {
            retArr.append( (results[i].valueForKey(type) as? String)! )
            
        }
        return retArr
        
    }
    
    func getNumberArray(results: [NSManagedObject], type: String) -> [NSNumber] {
        var retArr = [NSNumber]()

        for var i = 0; i < results.count; i++ {
                retArr.append( (results[i].valueForKey(type) as? NSNumber)! )
            
        }
        return retArr

    }
    
    func incrementCount(index: Int)
    {
        let fetchedResults = getFetchResults()
        let managedContext = self.getManagedContext()
        
        var error: NSError?

        if let results = fetchedResults {
            var newCount = counts[index].integerValue
            newCount++
        
            results[index].setValue(newCount, forKey: "visitedCount")
            
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
    }

    
}


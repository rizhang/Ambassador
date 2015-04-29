//
//  ManageViewController.swift
//  Ambassador
//
//  Created by Richard Zhang on 4/28/15.
//  Copyright (c) 2015 Richard Zhang. All rights reserved.
//

import UIKit
import CoreData
class ManageViewController: UIViewController, UITextFieldDelegate {

    var nameStr:String?
    var obj:NSManagedObject?
    @IBOutlet weak var name: UILabel?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var coolMessageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        nameTextField?.text = nameStr
        let orgFrame = self.nameTextField?.frame
        var fr = self.nameTextField?.frame
        fr?.origin.x = -screenWidth/2.0;
        self.nameTextField?.frame = fr!;
        UIView.animateWithDuration(0.5, animations: { () -> Void in

            self.nameTextField?.text = self.nameStr
            self.nameTextField?.frame = orgFrame!;
            
            }, completion: { (Boolean) -> Void in
                //add pause later
//                var frame = self.coolMessageLabel?.frame
//                frame?.size.height = 0;
//                self.coolMessageLabel?.frame = frame!;
                self.coolMessageLabel.alpha = 0.0;
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.coolMessageLabel.alpha = 1.0
                }, completion: { (Boolean) -> Void in

                })
                
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Textfield delegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.saveEdit()
        nameTextField.resignFirstResponder()
        return true;
    }
    
    func getManagedContext() -> NSManagedObjectContext {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        return managedContext
    }
    
    func saveEdit() {
        let context = self.getManagedContext()
        obj?.setValue(nameTextField.text, forKey: "titleText")
        var error: NSError?

        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  CheckoutViewController.swift
//  BMUNapp
//
//  Created by Michael Eliot on 11/12/16.
//  Copyright © 2016 Jake Moskowitz. All rights reserved.
//

import UIKit
import Moltin

class CheckoutViewController: UIViewController {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var billingAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var postcode: UITextField!
    @IBOutlet weak var totalLabel: UILabel!

    @IBOutlet weak var email: UITextField!
    
    init(total: String) {
        super.init(nibName: "CheckoutViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func confirmOrder(_ sender: AnyObject) {
        if self.emptyTextField() {
            print("wow no fucking way")
        } else {
            let id = Moltin.sharedInstance().cart.identifier()
            let orderParameters = [
                "customer": ["first_name": firstName.text!,
                             "last_name":  lastName.text!,
                             "email":      email.text!],
                "shipping": "free_shipping",
                "gateway": "dummy",
                "bill_to": ["first_name": firstName.text!,
                            "last_name":  lastName.text!,
                            "address_1":  billingAddress.text!,
                            "address_2":  "Sunnycreek",
                            "city":       city.text!,
                            "county":     state.text!,
                            "country":    country.text!,
                            "postcode":   postcode.text!,
                            "phone":     phoneNumber.text!],
                "ship_to": "bill_to"
            ] as [String : Any]
            Moltin.sharedInstance().cart.order(withParameters: orderParameters, success: { (response) -> Void in
                // Order succesful
                print("Order succeeded: \(response)")
                
                // Extract the Order ID so that it can be used in payment too...
                let orderID = ((response as! [String: AnyObject])["result"] as! [String: AnyObject])["id"]
                let alert = UIAlertController(title: "Purchase Processed", message: "Thank you for supporting BMUN! You're purchase was processed, and will be ready at the store!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("Order ID: \(orderID)")
                }, failure: { (response, error) -> Void in
                    // Order failed
                    print("Order error: \(error)")
            })
            if let bundle = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundle)
            }
            Moltin.sharedInstance().cart.delete(withId: id, success: { (response) -> Void in
                }, failure: { (response, error) -> Void in
                    // Delete Failed
                    print("Order error: \(error)")})
        }
    }
    
    func emptyTextField() -> Bool {
        let empty = ""
        if firstName.text == empty
        || lastName.text == empty
        || country.text == empty
        || phoneNumber.text == empty
        || billingAddress.text == empty
        || city.text == empty
        || state.text == empty
        || postcode.text == empty {
            return true
        } else {
            return false
        }
    }


}
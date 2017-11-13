//
//  SubscriptionViewController.swift
//  teleBang
//
//  Created by Admin on 5/23/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Paystack

class SubscriptionViewController: BaseController, NIDropDownDelegate, PSTCKPaymentCardTextFieldDelegate {

    @IBOutlet weak var btnSubscriptionType: UIButton!
    @IBOutlet weak var lblChargeAmount: UILabel!
    
    var dropDownSubscriptionType: NIDropDown? = nil
    let arrTypeName = ["1 month", "3 months", "6 months", "12 months"]
    var subscriptionType = 0
    // Find this at https://dashboard.paystack.co/#/settings/developer
    let paystackPublicKey = "pk_test_072172819201269dc2248e051196e7db6fd84dc5"//test key
    let paystackSecreteKey = "sk_test_1254a67b29e8ffafa4ed35e59493991761c70922"//test key
    
    // To set this up, see https://github.com/PaystackHQ/sample-charge-card-backend
//    let backendURLString = "https://telebang.herokuapp.com"

    
    let card : PSTCKCard = PSTCKCard()

    // MARK: Properties
    @IBOutlet weak var cardDetailsForm: PSTCKPaymentCardTextField!
    @IBOutlet weak var chargeCardButton: UIButton!
//    @IBOutlet weak var tokenLabel: UILabel!
    
    override func viewDidLoad() {
        

        // Do any additional setup after loading the view.
        // hide token label and email box
        
        chargeCardButton.isEnabled = false
        // clear text from card details
        // comment these to use the sample data set
        super.viewDidLoad()
    }
    func dismissKeyboardIfAny(){
        // Dismiss Keyboard if any
        cardDetailsForm.resignFirstResponder()
        
    }
    
    @IBAction func clickedSubscriptionType(_ sender: Any) {
        
        var height:CGFloat = 150.0
        if self.dropDownSubscriptionType == nil {
            self.dropDownSubscriptionType = NIDropDown().show(sender as! UIButton, &height, arrTypeName, nil, "down") as! NIDropDown?
            self.dropDownSubscriptionType?.delegate = self
        } else {
            self.dropDownSubscriptionType?.hide(sender as! UIButton)
            self.dropDownSubscriptionType = nil
        }

    }
    @IBAction func clickedCharge(_ sender: Any) {
        dismissKeyboardIfAny()
        
        // Make sure public key has been set
        if (paystackPublicKey == "" || !paystackPublicKey.hasPrefix("pk_")) {
            showOkayableMessage("You need to set your Paystack public key.", message:"You can find your public key at https://dashboard.paystack.co/#/settings/developer .")
            // You need to set your Paystack public key.
            return
        }
        
        Paystack.setDefaultPublicKey(paystackPublicKey)
        
        if cardDetailsForm.isValid {
            
            if RELATIVE_URL_GET_NEW_ACCESS_CODE != "" {
//                fetchAccessCodeAndChargeCard()
                getNewAccessCode()
                return
            }
            showOkayableMessage("Backend not configured", message:"To run this sample, please configure your backend.")
            
            
        }

    }
    @IBAction func cardDetailChanged(_ sender: PSTCKPaymentCardTextField) {
        chargeCardButton.isEnabled = sender.isValid
    }
    
//    func outputOnLabel(str: String){
//        DispatchQueue.main.async {
//            if let former = self.tokenLabel.text {
//                self.tokenLabel.text = former + "\n" + str
//            } else {
//                self.tokenLabel.text = str
//            }
//        }
//    }
    
//    func fetchAccessCodeAndChargeCard(){
//        showLoading()
//        if let url = URL(string: RELATIVE_URL_GET_NEW_ACCESS_CODE) {
//            self.makeBackendRequest(url: url, message: "fetching access code", completion: { str in
////                self.outputOnLabel(str: "Fetched access code: " + str)
//                self.chargeWithSDK(newCode: str as NSString)
//            })
//        }
//    }
    
    func chargeWithSDK(newCode: NSString){
        let transactionParams = PSTCKTransactionParams.init();
        transactionParams.access_code = newCode as String;
        // use library to create charge and get its reference
        PSTCKAPIClient.shared().chargeCard(self.cardDetailsForm.cardParams, forTransaction: transactionParams, on: self, didEndWithError: { (error, reference) -> Void in
            self.hideLoading()
            self.showOkayableMessage("Error", message: "Charge error")
//            self.outputOnLabel(str: "Charge errored")
            // what should I do if an error occured?
            print(error)
            if error._code == PSTCKErrorCode.PSTCKExpiredAccessCodeError.rawValue{
                // access code could not be used
                // we may as well try afresh
            }
            if error._code == PSTCKErrorCode.PSTCKConflictError.rawValue{
                // another transaction is currently being
                // processed by the SDK... please wait
            }
            if let errorDict = (error._userInfo as! NSDictionary?){
                if let errorString = errorDict.value(forKeyPath: "com.paystack.lib:ErrorMessageKey") as! String? {
                    if let reference=reference {
                        self.showOkayableMessage("An error occured while completing "+reference, message: errorString)
//                        self.outputOnLabel(str: reference + ": " + errorString)
                        self.verifyTransaction(reference: reference)
                    } else {
                        self.showOkayableMessage("An error occured", message: errorString)
//                        self.outputOnLabel(str: errorString)
                    }
                }
            }
            self.chargeCardButton.isEnabled = true;
        }, didRequestValidation: { (reference) -> Void in
            self.hideLoading()
        }, didTransactionSuccess: { (reference) -> Void in
            self.chargeCardButton.isEnabled = true;
            
            self.verifyTransaction(reference: reference)
            self.updateSubscription(reference: reference)
        })
        return
    }
    
    func verifyTransaction(reference: String){
        if let url = URL(string: RELATIVE_URL_VIERITY_SUBSCRIPTION) {
            makeBackendRequest(url: url, message: "verifying " + reference, completion:{(str) -> Void in
//                self.outputOnLabel(str: "Message from paystack on verifying " + reference + ": " + str)
                
            })
        }
    }
    
    func makeBackendRequest(url: URL, message: String, completion: @escaping (_ result: String) -> Void){
        let session = URLSession(configuration: URLSessionConfiguration.default)
//        self.outputOnLabel(str: "Backend: " + message)
        session.dataTask(with: url, completionHandler: { data, response, error in
            let successfulResponse = (response as? HTTPURLResponse)?.statusCode == 200
            if successfulResponse && error == nil && data != nil {
                if let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    completion(str as String)
                } else {
                    self.hideLoading()
//                    self.outputOnLabel(str: "<Unable to read response> while "+message)
                    print("<Unable to read response>")
                }
            } else {
                self.hideLoading()
                if let e=error {
                    print(e.localizedDescription)
//                    self.outputOnLabel(str: e.localizedDescription)
                } else {
                    // There was no error returned though status code was not 200
                    print("There was an error communicating with your payment backend.")
//                    self.outputOnLabel(str: "There was an error communicating with your payment backend while "+message)
                }
            }
        }).resume()
    }
    func getNewAccessCode()  {
        showLoading()
        ApiClient.getNewAccessCode(accountID: customerManager.getCustomerID(), type: self.subscriptionType, errorHandler: { (error) in
            self.hideLoading()
            print(error)
        }) {accessCode in
            
            self.chargeWithSDK(newCode: accessCode as NSString)
        }
    }

    
    func updateSubscription(reference: String)  {
        ApiClient.updateSubscription(accountID: customerManager.getCustomerID(), card_number: self.cardDetailsForm.cardParams.last4()!, paystack_auth_key: reference, subscribed_date: Int(AppUtil.currentTimestamp), type: self.subscriptionType, errorHandler: { (error) in
            self.hideLoading()
            print(error)
        }) {
            self.hideLoading()
            self.showSubscriptionSuccessMessage(reference)
        }
    }
    
    //MARK: NIDropDownDelegate
    func niDropDownDelegateMethod(_ sender: NIDropDown!) {
        if sender == self.dropDownSubscriptionType {
            
            print(sender.getSelectedIndex())
            var amount = 25
            self.subscriptionType = Int(sender.getSelectedIndex())
            switch sender.getSelectedIndex() {
            case 0:
                
                break
            case 1:
                amount = amount * 3
                break
            case 2:
                amount = amount * 6
                break
            case 3:
                amount = amount * 12
                break
            default:
                break
            }
            
            self.lblChargeAmount.text = "You will be charged " + String(amount) + " NGR"
            self.dropDownSubscriptionType = nil
        }
    }
    
    // MARK: Helpers
    func showOkayableMessage(_ title: String, message: String){
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func showSubscriptionSuccessMessage(_ reference: String){
        let alert = UIAlertController(
            title: title,
            message: "Subscription success with reference code: " + reference,
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) in
            customerManager.saveSubscription(paystack_auth_code: reference, subscription_date: Int(AppUtil.currentTimestamp))
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

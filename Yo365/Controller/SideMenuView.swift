//
//  SideMenuView.swift
//  Yo365
//
//  Created by Billy on 1/23/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher
import SlideMenuControllerSwift
class SideMenuView: BaseController, UITableViewDataSource, UITableViewDelegate {
    var elements: [SlideMenuElement] = []
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imvAvatar: UIImageView!
    @IBOutlet var lbUsername: UILabel!
    @IBOutlet var lbEmail: UILabel!
    
    let cellIdentifier = "SlideMenuCellScreen"
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        elements = try! SlideMenuElement.loadFromPlist()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        swicthScreen(indexPath: indexPath)
        
        initAccount()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.setStatusBarHidden(true, with: .none)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.setStatusBarHidden(false, with: .none)
//    }
//    
    func initAccount() {
        // Circular avatar
        imvAvatar.layer.cornerRadius = imvAvatar.frame.size.width / 2;
        //        imvAvatar.layer.borderWidth = 3.0
        //        imvAvatar.layer.borderColor = UIColor.red.cgColor
        imvAvatar.clipsToBounds = true;
        
        let urlAvatar = URL(string: customerManager.getCustomerAvatar())
        imvAvatar.kf.setImage(with: urlAvatar, placeholder: Image.init(named: "img_avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        lbUsername.text = customerManager.getFullName()
        lbEmail.text = customerManager.getCustomerModel().email
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doSetting(_ sender: UIButton) {
        let indexPath = IndexPath.init(row: -1, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingScreen") {
            self.slideMenuController()?.changeMainViewController(controller, close: true)
        }
    }
    
    @IBAction func tapAvatar(_ sender: UITapGestureRecognizer) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SlideMenuCell", owner: self, options: nil)?.first as! SlideMenuCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SlideMenuCell
        let row = indexPath.row
        cell.updateView(element: elements[row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        swicthScreen(indexPath: indexPath)
    }
    
    func swicthScreen(indexPath: IndexPath) {
        let row = indexPath.row
        var controller: UIViewController! = nil;
        
        switch elements[row].type {
        case .Home:
            let mainController = self.storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
            mainController.positionActive = 0
            controller = mainController
            break
            
        case .Categories:
            let mainController = self.storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
            mainController.positionActive = 1
            controller = mainController
            break
            
        case .Favourite:
            let mainController = self.storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
            mainController.positionActive = 3
            controller = mainController
            break
        case .Series:
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "SeriesPageScreen") as! UINavigationController
            controller = nav
            break
        case .Download:
            
            break
            
        case .Upload:
            
            break
            
        case .AboutUs:
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "StaticPageScreen") as! UINavigationController
            let pageController = nav.topViewController as! StaticPageController
            pageController.staticTitle = "About Us"
            pageController.staticPath = PAGE_ABOUT_US
            controller = nav
            break
            
        case .Feedback:
            UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/" + APP_STORE_ID)!)
            break
            
        case .Terms:
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "StaticPageScreen") as! UINavigationController
            let pageController = nav.topViewController as! StaticPageController
            pageController.staticTitle = "Terms And Conditions"
            pageController.staticPath = PAGE_TERM
            controller = nav
            break
            
        case .Help:
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "StaticPageScreen") as! UINavigationController
            let pageController = nav.topViewController as! StaticPageController
            pageController.staticTitle = "Help"
            pageController.staticPath = PAGE_HELP
            controller = nav
            break
            
        case .Share:
            let activityViewController = UIActivityViewController(activityItems: [String.init(format: "https://itunes.apple.com/app/%@", APP_STORE_ID) as NSString], applicationActivities: nil)
            present(activityViewController, animated: true, completion: {})
            break
            
        case .News:
            let newsController = NewsController(nibName: "NewsController", bundle: nil)
            let nav = UINavigationController(rootViewController: newsController)
            controller = nav
            
            break
        case .SubscriptionHistory:
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionNav") as! UINavigationController
            controller = nav
            break
        
        }
        
        if controller != nil {
            self.slideMenuController()?.changeMainViewController(controller, close: true)
        }
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(indexPath.row<0){
            return
        }
        
        let cellToDeSelect:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.white
    }
}

extension SideMenuView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        //        let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
        //        let imageName         = imageUrl.lastPathComponent
        
        dismiss(animated:true, completion: nil) //5
        showLoading(msg: "Please wait while the content loads")
        ApiClient.changeAvatar(customerID: customerManager.getCustomerID(), image: chosenImage, errorHandler: { (msg: String?) in
            self.hideLoading()
            self.showMessage(title: "Error", msg: msg!)
        }, successHandler: { (response: CustomerResponse?) in
            self.hideLoading()
            self.imvAvatar.image = chosenImage //4
            customerManager.onChangeProfileSuccessfully(customer: response!)
            self.showMessage(title: "Sucessfully", msg: "Change Avatar Successfully!")
        }) { (progressCompletted: Int) in
            self.updateOverlayText(String.init(format: "Processing... %d%%", progressCompletted))
        }
    }   
}

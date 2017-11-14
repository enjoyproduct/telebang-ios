//
//  SeriesViewController.swift
//  teleBang
//
//  Created by Admin on 11/14/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnOnAir: UIButton!
    @IBOutlet weak var btnMostView: UIButton!
    @IBOutlet weak var viewOnAir: UIView!
    @IBOutlet weak var viewMostView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onClickAir(_ sender: Any) {
    }
    @IBAction func onClickMostView(_ sender: Any) {
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

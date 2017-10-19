//
//  NotificationVC.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/18/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import UIKit
import CoreData

class NotificationVC: UIViewController {
    var favoritesArray: [NSManagedObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func setNotificationButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

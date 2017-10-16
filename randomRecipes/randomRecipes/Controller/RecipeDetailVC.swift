//
//  RecipeDetailVC.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/16/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailVC: UIViewController {
    var recipeObj: NSManagedObject!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeType: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = recipeObj.value(forKey: "recipeTitle") as? String {
            recipeTitle.text = title
        }
        
        if let Image = recipeObj.value(forKey: "recipeImage") as? Data {
            let image = UIImage(data: Image)
            // SDWebImage
            recipeImage.image = image
            recipeImage.layer.cornerRadius = 10
            recipeImage.layer.masksToBounds = true
        }
        
        if let type = recipeObj.value(forKey: "recipeType") as? String {
            recipeType.text = type
        }
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

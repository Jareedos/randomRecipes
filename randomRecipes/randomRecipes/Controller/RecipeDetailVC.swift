//
//  RecipeDetailVC.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/16/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeType: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var cookingInstructions: UITextView!
    
    var recipeObj: NSManagedObject!
    var IngANDMeasurementsArray = [(String, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: "IngredientTableViewCell")
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

        cookingInstructions.text = recipeObj.value(forKey: "recipeInstructions") as? String ?? "There arn't any cooking instructions available"
        
        
        guard let ingredientsArray = recipeObj.value(forKey:"recipeIngredients") as? [String] else {return}
        guard let measurementsArray = recipeObj.value(forKey: "recipeIngredientMeasurements") as? [String] else {return}
        
        for index in 0..<ingredientsArray.count {
                IngANDMeasurementsArray.append((measurementsArray[index], ingredientsArray[index]))
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngANDMeasurementsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell") as? IngredientTableViewCell else {
            fatalError("The World Is Ending")
        }
        let cellCount = indexPath.row + 1
        cell.cellCountLbl.text = String("\(cellCount).")
        cell.measurementLbl.text = IngANDMeasurementsArray[indexPath.row].0
        cell.IngredientLbl.text = IngANDMeasurementsArray[indexPath.row].1
        return cell
    }
    

    
}
